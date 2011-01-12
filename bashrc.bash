#!/bin/bash
# Setup file for bash.  To use this file, add this to your .bashrc:
#
#    . ~/local/etc/config/bashrc.bash
#
# or wherever you have stashed these files.  System specific configuration
# can also be added to your .bashrc before or after the call.
#

# Relative path to configure dir (the directory this script is located).
config_dir=$(dirname $BASH_SOURCE)

# Absolute path to configure dir
export KMOREL_CONFIG_DIR=$(${config_dir}/bin/fullpath $config_dir)
unset config_dir

