#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)

if $(gem list | grep fruit_processor)
then
    gem uninstall fruit_processor
fi

pushd ${REPO_ROOT}
cd ${REPO_ROOT}/fruit_processor_gem
rake clean
rake
gem install --user-install pkg/fruit_processor-3.4.3.gem
cd ${REPO_ROOT}
rake clean
rake
trap popd EXIT SIGINT SIGKILL
