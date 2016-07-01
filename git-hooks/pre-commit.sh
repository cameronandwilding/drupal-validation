#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/../settings.sh
. $DIR/../validate-code.sh

for PROJECT_PATH in $PROJECT_PATHS
do
  STAGED_FILES_CMD=`git diff --cached --name-only --diff-filter=ACMR HEAD -- ${PROJECT_PATH} | grep -v "${PROJECT_IGNORE}" | grep "${PROJECT_INCLUDE}"`
  validateCode "$STAGED_FILES_CMD"
done






