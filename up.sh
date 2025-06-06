#!/bin/bash

set -o errexit

title() {
  echo -e "\n================================"
  echo -e "$1"
  echo -e "--------------------------------"
}

action() {
  echo -e "\n>>> $1"
}

add_helm_repo() {
  if helm repo list | grep -q $1; then
    action "Update $1 repo"
    helm repo update $1
  else
    action "Add $1 repo"
    helm repo add $1 $2 --force-update
  fi
}

# ================================================================================================
title "INIT"
action "Create temp dir"
DIR=${DIR:-/tmp/devenv}
test -d "$DIR" || mkdir -p "$DIR"
IP=$(hostname -i | cut -d' ' -f1)

# ================================================================================================
title "REGISTRY"
REGNAME=${REGISTRY_NAME:-registry.sandbox.local}
REGPORT=${REGISTRY_PORT:-5001}

if [ "$(docker inspect -f '{{.State.Running}}' "$REGNAME" 2>/dev/null || true)" != 'true' ]; then
docker run -d --name "${REGNAME}" --restart=always \
  -p "127.0.0.1:${REGPORT}:5000" \
  --network bridge \
  registry:2
else
  action "Running already"
fi

# ================================================================================================
title "CLUSTER"
CLUNAME=${CLUSTER_NAME:-sandbox}

if  kind get clusters -q | grep -q sandbox; then
  action "Running already"
else
  action "Create cluster"
  cat << EOF | kind create cluster --name "$CLUNAME" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
nodes:
  - role: control-plane
    labels:
      feature.node.kubernetes.io/port-mapping: !!str true
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
      - containerPort: 443
        hostPort: 443
    extraMounts:
      - hostPath: $DIR/storage
        containerPath: /storage
        propagation: HostToContainer
EOF

  action "Add the registry config to the nodes"
  REGISTRY_DIR="/etc/containerd/certs.d/localhost:${REGPORT}"
  for node in $(kind get nodes --name "$CLUNAME"); do
    docker exec "${node}" mkdir -p "${REGISTRY_DIR}"
    cat <<EOF | docker exec -i "${node}" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${REGNAME}:5000"]
EOF
  done

  action "Connect the registry to the cluster network"
  docker network connect "kind" "${REGNAME}"

  action "Add ca-cert to the nodes"
  for node in $(kind get nodes --name "$CLUNAME"); do
    cat ca/ca.crt | docker exec -i "${node}" cp /dev/stdin "/usr/local/share/ca-certificates/ca.crt"
    docker exec -i "${node}" update-ca-certificates
    docker exec -i "${node}" systemctl restart containerd
  done
fi

# ================================================================================================
title "DNS"
if [ "$(docker inspect -f '{{.State.Running}}' "dns" 2>/dev/null || true)" != 'true' ]; then
  action "Create coredns.corefile"
  cat > "$DIR/coredns.corefile" << EOF
.:53 {
    forward . 8.8.8.8 8.8.4.4
    log
    errors
    health :8080
}

sandbox.local:53 {
    log
    errors
    file /etc/coredns/db.sandbox.local
}


EOF

  action "Create coredns.zonefile"
  cat > "$DIR/coredns.zonefile" << EOF
\$ORIGIN sandbox.local.
@         IN  SOA dns.sandbox.local. dummy.local.local. 2505011720 7200 3600 1209600 3600

*         IN  A $IP
EOF

  action "Pull CoreDNS image"
  docker pull coredns/coredns

  action "Start Coredns"
  docker run -d --name dns --restart=always\
    -p 53:53/tcp -p 53:53/udp \
    -v "$DIR/coredns.corefile":/etc/coredns/Corefile \
    -v "$DIR/coredns.zonefile":/etc/coredns/db.sandbox.local \
    coredns/coredns:latest -conf /etc/coredns/Corefile -dns.port 53
else
  action "Running already"
fi

# ================================================================================================
title "CERT MANAGER"
add_helm_repo jetstack https://charts.jetstack.io 

action "Deploy chart"
if helm list --all-namespaces --all | grep -q "cert-manager"; then
  echo "Already installed"
else
  helm install cert-manager jetstack/cert-manager --version v1.17.2 --hide-notes \
    --namespace cert-manager --create-namespace \
    --set crds.enabled=true 
fi

action "Deploy cluster CA issuer and secret"
if kubectl get secret --namespace cert-manager | grep -q ca-cert; then
  echo "Already deployed"
else
  kubectl create secret tls --namespace cert-manager ca-cert \
    --cert=./ca/ca.crt \
    --key=./ca/tls.key

  cat << EOF | kubectl apply --server-side -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ca-issuer
spec:
  ca:
    secretName: ca-cert
EOF
fi

# ================================================================================================
title "INGRESS CONTROLLER"
if kubectl get namespaces | grep -q ingress-nginx; then
  echo "Already installed"
else
  kubectl apply --server-side -f ./ingress-controller.yaml
fi