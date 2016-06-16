#!/bin/bash

# Sets up ls and aliases.  This script can be sourced by bash and zsh.

LS_OPT="-F -I 'NTUSER.DAT{*'"

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

if quiet_which gls
then
    ls_command=gls
else
    ls_command=ls
fi

alias ls="$ls_command $LS_OPT"
alias la="$ls_command -a $LS_OPT"
alias ll="$ls_command -al $LS_OPT"
