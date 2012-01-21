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

. "$config_dir/shell-startup/basic-environment.sh"
. "$config_dir/shell-startup/path-setup.sh"
. "$config_dir/shell-startup/aliases.bash"
. "$config_dir/shell-startup/os-specific.bash"
. "$config_dir/shell-startup/developer-setup.bash"

unset config_dir

export SHELL=/bin/zsh
