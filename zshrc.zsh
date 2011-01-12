#!/bin/zsh
# Setup file for bash.  To use this file, add this to your .zshrc:
#
#    . ~/local/etc/config/zshrc.zsh
#
# or wherever you have stashed these files.  System specific configuration
# can also be added to your .zshrc before or after the call.
#

# Relative path to configure dir (the directory this script is located).
config_dir=$(dirname $0)

# Absolute path to configure dir
export KMOREL_CONFIG_DIR=$(${config_dir}/bin/fullpath $config_dir)
unset config_dir
