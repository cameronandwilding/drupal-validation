#!/bin/sh

# This file sets the default configuration values if nothing else is specified
# at settings.cfg file. This will only work with optional values.

. settings.cfg

if [ "$PROJECT_IGNORE" == "" ]; then
  PROJECT_IGNORE='/libraries/\|/contrib/'
fi

if [ "$PROJECT_INCLUDE" == "" ]; then
  PROJECT_INCLUDE='\.php\|\.module\|\.inc\|\.install'
fi