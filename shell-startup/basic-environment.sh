#!/bin/sh
# Sets up basic common environment.  This script can be sourced by sh and
# any variant.

export EDITOR=vi
export VISUAL=vi
export PAGER=less

umask 022

export LESS="-i -M"

export CVS_RSH=/usr/bin/ssh

stty erase '^?'
