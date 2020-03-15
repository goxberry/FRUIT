#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)

pushd ${REPO_ROOT}
git restore *.f90
git restore *.f95
git restore *.f03
git restore *.f08
git restore */*.f90
git restore *.rb
git restore */*.rb
git restore */*/*.rb
git restore src/fruit_f90_source.txt
trap popd EXIT SIGINT SIGKILL
