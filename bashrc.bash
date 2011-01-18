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

. $KMOREL_CONFIG_DIR/shell-startup/basic-environment.sh
. $KMOREL_CONFIG_DIR/shell-startup/path-setup.sh
. $KMOREL_CONFIG_DIR/shell-startup/os-specific.bash
. $KMOREL_CONFIG_DIR/shell-startup/ls-setup.bash
. $KMOREL_CONFIG_DIR/shell-startup/aliases.bash
. $KMOREL_CONFIG_DIR/shell-startup/developer-setup.bash

. $KMOREL_CONFIG_DIR/shell-startup/git-completion.bash

#############################################################################
# Set up key bindings.
set -o vi                                       # Vi-like editing
bind -m vi-insert '\C-a:beginning-of-line'      # With some emacs-like keys
bind -m vi-insert '\C-e:end-of-line'
bind -m vi-insert '\C-r:reverse-search-history'
bind -m vi-insert '\C-s:forward-serach-history'
bind -m vi-insert '\C-d:delete-char'

#############################################################################
# Set up prompt.
bold=$(tput bold)
red=$(tput setaf 1)
cyan=$(tput setaf 6)
reset=$(tput sgr0)
PS1='\h:\[$bold$red\]\w\[$reset\]$(__git_ps1 ",\[$cyan\]%s\[$reset\]") $?> '

alias where='which'
