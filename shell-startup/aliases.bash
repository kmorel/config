#!/bin/bash

# Sets up common aliases.  This script can be sourced by bash and zsh.

alias mv='mv -i'
alias cp='cp -i'
#alias rm='rm -i'

function cvsmod() {
    sh -c "cvs -n up $* 2> /dev/null" | grep -v '[ /]makeme'
}
function cvsmodr() {
    cvsmod | grep -v ^\?
}
function cvschangeroot() {
    find . -path '*/CVS/Root' -exec echo echo $1 \> {} \; | sh
}

function svnmod() {
    $SHELL -c 'svn -u status "$@"' | grep -v '[ /\\]makeme'
}

function svnstat() {
    $SHELL -c 'svn status "$@"' | grep -v '[ /\\]makeme'
}

alias e='gnuclient -q'

function xt() {
    xterm "$@" -sb -sl 2048 +tb -geometry 80x40 -rv -T xterm@`hostname` -e $SHELL &
}

# Get help about a cmake command.
function cmakecom() {
    cmake --help-command "$@" | less
}
# Get help about a cmake variable
function cmakevar() {
    cmake --help-variable "$@" | less
}
# Get help about a cmake module
function cmakemod() {
    cmake --help-module "$@" | less
}

# Allows you to pop up several images with ImageMag
function display_image_failure() {
    for file ; do
        display $file &
    done
}

# I want to strangle the person who decided to output the results of
# 'module avail' to standard error. WTF?
alias moduleavail='module avail 2>&1 | less'
