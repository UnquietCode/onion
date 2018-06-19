#!/bin/bash
set -ex

if [[ $# < 2 ]]; then
  echo "usage: <template directory> <template file>"
  exit 1
fi

docker run --volume "$1:/templates" unquietcode/onion "$2"