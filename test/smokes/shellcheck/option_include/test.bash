#!/bin/bash

foo() {
  if [[ -z $1 ]]
  then
    break
  fi
}

case "$1" in
  -v)
    verbose=1
    break
    ;;
  -d)
    debug=1
esac
