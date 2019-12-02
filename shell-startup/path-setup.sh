#!/bin/sh

# Gets ready to add custom things to the path and adds the paths that I
# consistently use.  This script can be sourced by sh and any variant.

# before_system_path=
# system_path=${PATH}
# after_system_path=

# Used internally
detect_system_path() {
    system_path=`echo ${PATH} | sed -e "s|${before_system_path:-/not/a/path}||g" -e "s|${after_system_path}:\.||g"`
}

# Used internally
update_path() {
    export PATH=${before_system_path}${system_path}${after_system_path}:.
}

# Add one or more directories to PATH before the system paths.
add_before_system_path() {
    detect_system_path
    for dir ; do
	if [ -d $dir ] ; then
	    if echo ${before_system_path} | fgrep -v ${dir}: > /dev/null
	    then
		before_system_path=${before_system_path}${dir}:
	    fi
	fi
    done
    update_path
}

# Add one or more directories to PATH after the system paths.
add_after_system_path() {
    detect_system_path
    for dir ; do
	if [ -d $dir ] ; then
	    if echo ${after_system_path} | fgrep -v :${dir} > /dev/null
	    then
		after_system_path=${after_system_path}:${dir}
	    fi
	fi
    done
    update_path
}

# Add custom command in home directory first
add_before_system_path \
    $HOME/local/bin

# /usr/local/bin should be in our path, but add it just in case it is not.
# Add it after the system path so that it does not overwrite custom path.
add_after_system_path \
    /usr/local/bin

# Make sure X programs are in path.
if quiet_which xterm ; then
    :
else
    add_after_system_path \
	/usr/local/X11/bin \
	/usr/local/X11R6/bin \
	/usr/X11R6/bin
fi
