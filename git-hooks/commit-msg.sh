#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/../settings.sh

if ! grep -iqE "$COMMIT_REGEX" "$1"; then
  echo "Aborting commit. Your commit message is missing information. Expecting $COMMIT_REGEX" >&2
  exit 1
fi
