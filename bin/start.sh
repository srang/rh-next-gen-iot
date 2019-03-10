#!/usr/bin/env bash
set -x
export NAMESPACE='esp-edge-compute-a'
export KEY_PASS='dmedge'
./bootstrap-ns.sh
./gen-secrets.sh
./deploy-author.sh

