#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "usage: $0 SPARK_VERSION"
  exit 1
fi

SPARK_VERSION=$1

test $(python /tmp/tests/printSparkVersion.py) == $SPARK_VERSION

