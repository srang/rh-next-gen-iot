#!/usr/bin/env bash
set -x
export NAMESPACE='edge-compute'
./bootstrap-ns.sh
./deploy-author.sh

