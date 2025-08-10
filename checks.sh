#!/bin/bash

echo "Checking scripts requirements..."

fn_test() {
  if which $1 > /dev/null  2>&1; then
    echo " ✅ $1"
  else if [[ "$2" = "optional" ]]; then
      echo " 🟠 $1 not detected. It's optional but requirement for certain modules."
    else
      echo " ❌ $1 not detected, please install it"
    fi
  fi
}


fn_test kind
fn_test kubectl
fn_test helm
fn_test docker
fn_test telepresence optional