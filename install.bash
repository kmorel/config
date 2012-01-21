#!/bin/bash

# Simple script to install this configuration in the current home directory.

# Relative path to configure dir (the directory this script is located).
config_dir=$(dirname "$BASH_SOURCE")

# Absolute path to configure dir
export KMOREL_CONFIG_DIR=$("${config_dir}/bin/fullpath" "$config_dir")

setup_login_file() {
    login_file=$1
    config_file=$2
    source_line=". '$config_file'"

    if [ -f "$login_file" ] ; then
	if fgrep "$source_line" "$login_file" > /dev/null ; then
	    :
	else
	    mv "$login_file" "$login_file.old"
	    echo $source_line > "$login_file"
	    echo >> "$login_file"
	    cat "$login_file.old" >> "$login_file"

	    echo "#######################################################"
	    echo "Added the following to $login_file:"
	    echo
	    echo "    $source_line"
	    echo
	    echo "Consider checking the rest of this file to ensure that"
	    echo "the rest of the file is necessary or should not be moved"
	    echo "the tracked configuration."
	    echo
	fi
    else
	echo $source_line > "$login_file"

	echo "#######################################################"
	echo "Created $login_file"
	echo
    fi
}

setup_symbolic_link() {
    target=$1
    source=$2

    if [ -f "$target" ] ; then
	if [ -L "$target" -a "$(readlink '$target')" = "$source" ] ; then
	    # Link is already correct.
	    :
	else
	    mv "$target" "$target.old"
	    ln -s "$source" "$target"

	    echo "#######################################################"
	    echo "Moved $target to $target.old"
	    echo "Replaced it with a symbolic link to $source"
	    echo
	fi
    else
	ln -s "$source" "$target"

	echo "#######################################################"
	echo "Created $target"
	echo "as a symbolic link to $source"
	echo
    fi
}

setup_login_file "${HOME}/.bashrc" "${KMOREL_CONFIG_DIR}/bashrc.bash"
setup_login_file "${HOME}/.zshrc" "${KMOREL_CONFIG_DIR}/zshrc.zsh"
setup_login_file "${HOME}/.zshenv" "${KMOREL_CONFIG_DIR}/zshenv.zsh"

setup_symbolic_link "${HOME}/.gitconfig" "${KMOREL_CONFIG_DIR}/gitconfig"
setup_symbolic_link "${HOME}/.gitignore" "${KMOREL_CONFIG_DIR}/gitignore"
