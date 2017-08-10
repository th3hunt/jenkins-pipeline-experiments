#!/bin/sh
#
# Usage: test.sh [exit_status]
#

echo "Running tests..."

if [[ $1 == 0 ]]; then
  echo "Success"
  exit 0
else
  echo "Failure"
  exit 1
fi
