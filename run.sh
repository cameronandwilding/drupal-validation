#!/bin/sh

. settings.sh
. validate-code.sh

#######################################
# Help method to show the options available in the script.
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
# Returns:
#   None
#######################################
help() {
  echo "$(basename "$0") [-hcbrn] [-r DRUPAL_ROOT] [-i PRIVATE_KEY] [-t LOCAL_TMP] [-p SSH_OPTS] -- Synchronization script for Sage environments

where:
    -h  show this help text
    -d  enables full debug/verbose mode.
    -p  prints configuration.
"
}

# Preparing the options of the script
while getopts "hdp" opt; do
  case "$opt" in
    h)
      help
      exit 1
      ;;
    d)
      DEBUG="TRUE"
      echo "Enabling debug: $DEBUG"
      ;;
    p)
      echo "Printing loaded configuration:"
      echo "- COMMIT_REGEX has value ${COMMIT_REGEX}"
      echo "- PROJECT has value ${PROJECT}"
      IS_ARRAY=`is_array "$PROJECT_PATHS"`
      if [ "$IS_ARRAY" == "1" ]; then
        for PROJECT_PATH in $PROJECT_PATHS
        do
          echo "-- ${PROJECT_PATH} included in the validation ..."
        done
      fi
      echo "- PROJECT_INCLUDE has value ${PROJECT_INCLUDE}"
      echo "- PROJECT_IGNORE has value ${PROJECT_IGNORE}"
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      help
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      help
      exit 1
      ;;
  esac
done

for PROJECT_PATH in $PROJECT_PATHS
do
  # Add | sed -e "s|$1/||g" for relative paths.
  FILES=`find -L $PROJECT_PATH -name '*.*' | grep -v "${PROJECT_IGNORE}" | grep "${PROJECT_INCLUDE}"`
  debug "Found the following files to process:" "$FILES"
  #validateMessDetector "$FILES" TRUE
  #validateCodeSniffer "$FILES"
  validateCopyPasteDetector $FOLDERS
done