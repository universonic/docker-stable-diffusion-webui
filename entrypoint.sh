#!/usr/bin/env bash

pushd /app/stable-diffusion-webui
./webui.sh "$@"
popd
