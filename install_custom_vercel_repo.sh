#!/usr/bin/env bash

set -eux
echo "Installing custom VECEL provider"
if [[ "$(uname)" = "Darwin" ]]; then
    VERCEL_PATH=~/.terraform.d/plugins/pollen.co/pollen/vercel/0.1/darwin_arm64
    mkdir -p ${VERCEL_PATH}
    curl -L "https://github.com/streetteam/terraform-provider-vercel/releases/download/gitsource-alpha-0.0.1/terraform-provider-vercel-m1-arm64" -o ${VERCEL_PATH}/terraform-provider-vercel
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    VERCEL_PATH=~/.terraform.d/plugins/pollen.co/pollen/vercel/0.1/linux_amd64
    mkdir -p ${VERCEL_PATH}
    curl -L "https://github.com/streetteam/terraform-provider-vercel/releases/download/gitsource-alpha-0.0.1/terraform-provider-vercel-linux-amd64" -o ${VERCEL_PATH}/terraform-provider-vercel
fi
chmod +x ${VERCEL_PATH}/terraform-provider-vercel 
