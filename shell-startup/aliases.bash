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
    xterm "$@" -sb -sl 2048 -rv -rw -geometry 100x50 -T xterm@`hostname` -e $SHELL &
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

# Check the formatting of a given file
function check-format() {
    if [ $# -ne 1 ]
    then
	echo "USAGE: $0 <filename>"
	return 1
    fi
    if clang-format -style=file $1 | diff $1 - > /dev/null
    then
	echo Correct formatting for $1
	return 0
    else
	echo BAD FORMATTING for $1
	echo Use try-reformat to see what needs to be reformatted
	echo or use do-reformat to apply reformatting.
	return 1
    fi
}

# See what would happen if you reformatted a file with clang-format
function try-reformat() {
    if [ $# -ne 1 ]
    then
	echo "USAGE: $0 <filename>"
	return 1
    fi
    clang-format -style=file $1 | diff $1 - | less
}

# Reformat the given file overwriting the data
function do-reformat() {
    if [ $# -ne 1 ]
    then
	echo "USAGE: $0 <filename>"
	return 1
    fi
    clang-format -style=file -i $1
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
