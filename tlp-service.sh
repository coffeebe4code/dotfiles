#!/bin/sh -e
#
# tlp-service
#
#
# To enable or disable this script, just change the execution
# bits.
#
# By default, this script does nothing.

if ! [ -x "$(command -v tlp)" ]; then
  exit 0
fi
tlp start

exit 0
