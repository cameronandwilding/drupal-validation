#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DEBUG="FALSE"

PHP_CS=${DIR}/vendor/bin/phpcs
PHP_MD=${DIR}/vendor/bin/phpmd
PHP_CPD=${DIR}/vendor/bin/phpcpd
PHP_CS_CODING_STANDARD=${DIR}/vendor/drupal/coder/coder_sniffer

######################################
# Checks if a variable is an array.
#
# @see https://gist.github.com/coderofsalvation/8377369
#
# Returns:
#  0 on sucess, 1 otherwise
######################################
is_array() {
    [ -z "$1" ] && return 1
    if [ -n "$BASH" ]; then
        declare -p ${1} 2> /dev/null | grep 'declare \-a' >/dev/null && echo 0
    fi
    echo 1
}

######################################
# Prints data if debug is enabled.
######################################
debug() {
  if [ "$DEBUG" == "TRUE" ]; then
    echo "[STEP] $1"
    IS_ARRAY=`is_array "$2"`
    if [ "$IS_ARRAY" == "1" ]; then
      for DATA in $2
      do
        echo "- processing ${DATA} ..."
      done
    else
      echo "- processing $2 ..."
    fi
  fi
}

######################################
# Validates through mess detector
#
# Arguments:
#  FILES array of files to check.
#  CONTINUE_ON_FAIL if we don't want to stop after the first error.
######################################
validateMessDetector() {
  FILES=$1
  CONTINUE_ON_FAIL=$2

  if [ ! -x $PHP_MD ]; then
    echo "PHP Mess detector bin not found or executable -> $PHP_MD"
    exit 1
  fi

  echo "Checking PHP Mess Detector..."
  for FILE in $FILES
  do
    if  [[ $FILE != /* ]] ;
    then
      FILE=$PROJECT/$FILE
    fi

    echo "- Checking $FILE ..."
    $PHP_MD $FILE text ${DIR}/rules.xml
    if [ $? != 0 ] && [ "$CONTINUE_ON_FAIL" == "" ]
    then
      # The PHPMD errors are reviewed, this does not block the commit.
      echo "Review the errors."
      exit $?
    fi
  done
}

######################################
# Validates through code sniffer
#
# Arguments:
#  FILES array of files to check.
######################################
validateCodeSniffer() {
  FILES=$1

  if [ ! -x $PHP_CS ]; then
    echo "PHP CodeSniffer bin not found or executable -> $PHP_CS"
    exit 1
  fi

  debug "Running Code Sniffer..." "$FILES"
  $PHP_CS --config-set installed_paths $PHP_CS_CODING_STANDARD
  if [ "$FILES" != "" ]
  then
      # The PHPCS errors are reviewed, this does not block the commit.
    $PHP_CS --standard=Drupal $FILES
    if [ $? != 0 ]
    then
      echo "Review the errors."
      exit $?
    fi
  fi
}

######################################
# Validates through copy paste detector
#
# Globals:
#  PROJECT_PATHS to analyse
######################################
validateCopyPasteDetector() {
  debug "Running Copy Paste detector..." "$PROJECT_PATHS"
  INCLUDE=`echo "$PROJECT_INCLUDE" | sed -e 's|\\\|\*|g' | sed -e "s/|/,/g"`
  $PHP_CPD --names=$INCLUDE --names-exclude="*views_default.inc" $PROJECT_PATHS
  if [ $? != 0 ]
  then
    # The PHPCPD errors are never allowed, they block the commit.
    echo "Commit blocked. Fix the copy paste errors."
    exit 1
  fi
  exit $?
}

######################################
# Executes a full validation.
######################################
validateCode() {
  validateMessDetector "$@"
  validateCodeSniffer "$@"
  validateCopyPasteDetector
}
