#!/usr/bin/env bash

submodules=("jsetup-utils" "cardano-cli-guru" "cardano-ez-installer" "aiken-druid")

for submodule in "${submodules[@]}"
do
  if [ ! "$(ls -A $submodule)" ]; then
    git submodule update --init --recursive
    git submodule foreach 'git checkout main'
    break
  fi
done