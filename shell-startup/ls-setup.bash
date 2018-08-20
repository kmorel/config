#!/bin/bash

# Sets up ls and aliases.  This script can be sourced by bash and zsh.

if quiet_which gls
then
    ls_command=gls
else
    ls_command=ls
fi

LS_OPT="-F"

# Set up files to ignore if supported
if $ls_command -I ignore-this > /dev/null 2> /dev/null
then
    LS_OPT="$LS_OPT -I 'NTUSER.DAT{*'"
fi

# Set up ls colors.
DIR_COLORS=$KMOREL_CONFIG_DIR/shell-startup/DIR_COLORS

if quiet_which dircolors
then
    eval `dircolors -b "$DIR_COLORS"`
    LS_OPT="$LS_OPT --color=auto"
elif quiet_which gdircolors
then
    eval `gdircolors -b "$DIR_COLORS"`
    LS_OPT="$LS_OPT --color=auto"
else
    :
fi

alias ls="$ls_command $LS_OPT"
alias la="$ls_command -a $LS_OPT"
alias ll="$ls_command -al $LS_OPT"
