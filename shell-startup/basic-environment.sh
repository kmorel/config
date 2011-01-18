#!/bin/sh
# Sets up basic common environment.  This script can be sourced by sh and
# any variant.

export EDITOR=vi
export VISUAL=vi
export PAGER=less

umask 022

export LESS="-i -M"

export CVS_RSH=/usr/bin/ssh

if [ -n "$PS1" ] ; then
    # Executed only for interactive shells.
    stty erase '^?'
fi

quiet_which() {
    which "$@" > /dev/null 2> /dev/null
}
