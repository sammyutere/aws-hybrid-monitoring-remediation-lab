#!/usr/bin/env bash

docker run --rm -it \
  -v "$PWD:/workspace" \
  -w /workspace \
  -v "$HOME/.aws:/root/.aws:ro" \
  hashicorp/terraform:1.6.6 "$@"
