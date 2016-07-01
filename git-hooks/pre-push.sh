#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/../settings.sh
. $DIR/../validate-code.sh

for PROJECT_PATH in $PROJECT_PATHS
do
  BRANCH_FILES=`git diff develop --name-only -- ${PROJECT_PATH} | grep -v "${PROJECT_IGNORE}" | grep "${PROJECT_INCLUDE}"`
  validateCode "$BRANCH_FILES"
done
