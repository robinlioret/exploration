#!/bin/bash

title() {
  echo -e "\n================================"
  echo -e "$1"
  echo -e "--------------------------------"
}

action() {
  echo -e "\n>>> $1"
}

title "DELETE DNS"
docker rm -f dns

title "DELETE REGISTRY"
REGNAME=${REGISTRY_NAME:-registry-sandbox}
docker rm -f "$REGNAME"

title "DELETE CLUSTER"
CLUNAME=${CLUSTER_NAME:-sandbox}
kind delete cluster --name "$CLUNAME"