#!/bin/bash

# helper script for executing WriteTemplate using the
# locally installed coffee executable

if [ "$#" -ne 1 ]; then
  echo "usage: <configuration.json>"
  exit 1
fi

# optionally install dependencies
# npm install

./node_modules/coffee-script/bin/coffee src/WriteTemplate.coffee $1
