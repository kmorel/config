#!/bin/sh
# Sets up basic common environment.  This script can be sourced by sh and
# any variant.

export EDITOR=vi
export VISUAL=vi
export PAGER=less

umask 022

export LESS="-i -M -R"

export CVS_RSH=/usr/bin/ssh

if [ -n "$PS1" ] ; then
    # Executed only for interactive shells.
    stty erase '^?'
fi

quiet_which() {
    which "$@" > /dev/null 2> /dev/null
}

# These are read by some editors (such as emacs) to set the default encoding
# for unicode text files. You'd think that they would default to UTF-8, but
# not always.
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8

export LATEX_DEFAULT_BUILD=dvi
