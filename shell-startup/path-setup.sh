#!/bin/sh

# Gets ready to add custom things to the path and adds the paths that I
# consistently use.  This script can be sourced by sh and any variant.

if echo ${PATH} | fgrep -v "${HOME}/local/bin" >& /dev/null
then
    add_to_path=1
else
    add_to_path=0
fi

before_system_path=
system_path=${PATH}
after_system_path=

# Used internally
update_path() {
    export PATH=${before_system_path}${system_path}${after_system_path}:.
}

# Add one or more directories to PATH before the system paths.
add_before_system_path() {
    if [ "${add_to_path}" != "1" ] ; then
	return
    fi
    for dir ; do
	if [ -d $dir ] ; then
	    before_system_path=${before_system_path}${dir}:
	fi
    done
    update_path
}

# Add one or more directories to PATH after the system paths.
add_after_system_path() {
    if [ "${add_to_path}" != "1" ] ; then
	return
    fi
    for dir ; do
	if [ -d $dir ] ; then
	    after_system_path=${after_system_path}:${dir}
	fi
    done
    update_path
}

add_before_system_path \
    $HOME/local/bin \
    /usr/local/bin

# Make sure X programs are in path.
if which xterm > /dev/null ; then
    :
else
    add_after_system_path \
	/usr/local/X11/bin \
	/usr/local/X11R6/bin \
	/usr/X11R6/bin
fi
