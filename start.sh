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
DIR=${DIR:-$HOME/devenv}
test -d "$DIR" || mkdir -p "$DIR"
IP=$(hostname -i | cut -d' ' -f1)
REGNAME=${REGISTRY_NAME:-registry.sandbox.local}
REGPORT=${REGISTRY_PORT:-5001}
CLUNAME=${CLUSTER_NAME:-sandbox}
ENABLE_REGISTRY=${REGISTRY:-false}
ENABLE_ARGOCD=${ARGOCD:-false}
ENABLE_FORGEJO=${FORGEJO:-false}

# ================================================================================================
title "CLUSTER"
if  kind get clusters -q | grep -q sandbox; then
  action "Running already"
else
  action "Create cluster"
  cat << EOF | kind create cluster --name "$CLUNAME" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
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
  helm install cert-manager jetstack/cert-manager --version v1.17.2 --hide-notes  --wait \
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
  kubectl wait --for condition=ready --namespace ingress-nginx \
    --selector app.kubernetes.io/name=ingress-nginx \
    --selector app.kubernetes.io/component=controller \
    --timeout 180s \
    pod
fi

# ================================================================================================
title "REGISTRY"
if $ENABLE_REGISTRY; then
  if kubectl get namespaces | grep -q registry; then
    echo "Already installed"
  else
    kubectl apply --server-side -f ./registry.yaml
  fi
else
  echo "Disabled"
fi

# ================================================================================================
title "FORGEJO"
if $ENABLE_FORGEJO; then
  if kubectl get namespaces | grep -q forgejo; then
    echo "Already installed"
  else
    kubectl apply --server-side -f ./forgejo.yaml
  fi
else
  echo "Disabled"
fi

# ================================================================================================
title "ARGOCD"
if $ENABLE_ARGOCD; then
  add_helm_repo argo https://argoproj.github.io/argo-helm

  action "Deploy ArgoCD"
  if helm list --all-namespaces --all | grep -q "argocd"; then
    echo "Already installed"
  else
    helm install argocd argo/argo-cd --hide-notes --wait --version 8.0.15 \
      --namespace argocd --create-namespace \
      -f ./argocd.values.yaml
  fi
else
  echo "Disabled"
fi