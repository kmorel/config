#!/bin/zsh
# Setup file for zsh.  To use this file, add this to your .zshenv:
#
#    . ~/local/etc/config/zshenv.zsh
#
# or wherever you have stashed these files.  System specific configuration
# can also be added to your .zshenv before or after the call.
#

# Relative path to configure dir (the directory this script is located).
config_dir=$(dirname $0)

# Absolute path to configure dir
export KMOREL_CONFIG_DIR=$(${config_dir}/bin/fullpath $config_dir)
unset config_dir

. $KMOREL_CONFIG_DIR/shell-startup/basic-environment.sh
. $KMOREL_CONFIG_DIR/shell-startup/path-setup.sh
. $KMOREL_CONFIG_DIR/shell-startup/aliases.bash
. $KMOREL_CONFIG_DIR/shell-startup/os-specific.bash
. $KMOREL_CONFIG_DIR/shell-startup/ls-setup.bash
. $KMOREL_CONFIG_DIR/shell-startup/developer-setup.bash

export SHELL=/bin/zsh
