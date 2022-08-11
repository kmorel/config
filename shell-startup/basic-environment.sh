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
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# I am currently having a problem with vim refreshing its screen unless
# you set LANG to C, which overrides any localization to use standard C
# syntax (e.g. letters are a-z, numbers us . for decimal). This is
# pretty close to US encoding anyway.
export LANG=C
export LANGUAGE=C
export LC_ALL=C

export LATEX_DEFAULT_BUILD=dvi
