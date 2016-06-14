#!/bin/bash

# Simple script to install this configuration in the current home directory.

# Relative path to configure dir (the directory this script is located).
config_dir=$(dirname "$BASH_SOURCE")

# Absolute path to configure dir
export KMOREL_CONFIG_DIR=$("${config_dir}/bin/fullpath" "$config_dir")

setup_config_file() {
    user_file=$1
    include_line=$2
    shift 2
    other_lines="$@"

    # Special case: a link is located here (probably from an old configuration).
    if [ -L "$user_file" ] ; then
        echo "#######################################################"
        echo "Removing link $user_file"
        rm "$user_file"
    fi

    if [ -f "$user_file" ] ; then
        if fgrep "$include_line" "$user_file" > /dev/null ; then
            :
        else
            mv "$user_file" "$user_file.old"
            echo $include_line > "$user_file"
            for line in "$other_lines" ; do
                echo $line >> "$user_file"
            done
            echo >> "$user_file"
            cat "$user_file.old" >> "$user_file"

            echo "#######################################################"
            echo "Added the following to $user_file:"
            echo
            echo "    $include_line"
            echo
            echo "Consider checking the rest of this file to ensure that"
            echo "the rest of the file is necessary or should not be moved"
            echo "the tracked configuration."
            echo
        fi
    else
        echo $include_line > "$user_file"
        for line in "$other_lines" ; do
            echo $line >> "$user_file"
        done

        echo "#######################################################"
        echo "Created $user_file"
        echo
    fi
}

setup_login_file() {
    login_file=$1
    config_file=$2
    source_line=". '$config_file'"
    setup_config_file "$1" "$source_line"
}

setup_symbolic_link() {
    target=$1
    source=$2

    if [ -f "$target" ] ; then
        if [ -L "$target" -a "$(readlink $target)" = "$source" ] ; then
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
        # Special case: a dead link is located here (probably from an old
        # configuration with outdated targerts).
        if [ -L "$target" ] ; then
            echo "#######################################################"
            echo "Removing dead link $target"
            rm "$target"
        fi

        ln -s "$source" "$target"

        echo "#######################################################"
        echo "Created $target"
        echo "as a symbolic link to $source"
        echo
    fi
}

mkdir -p "${HOME}/local/bin"
for binfile in "${KMOREL_CONFIG_DIR}/bin/"* ; do
    targetfile="${HOME}/local/bin/"`basename "$binfile"`
    setup_symbolic_link "$targetfile" "$binfile"
done

setup_login_file "${HOME}/.bashrc" "${KMOREL_CONFIG_DIR}/bashrc.bash"
setup_login_file "${HOME}/.zshrc" "${KMOREL_CONFIG_DIR}/zshrc.zsh"
setup_login_file "${HOME}/.zshenv" "${KMOREL_CONFIG_DIR}/zshenv.zsh"

if git_version_string=`git --version`
then
    git_version=`echo $git_version_string | sed -n 's/[^0-9]*\([0-9]*\)\.\([0-9]*\).*$/\1.\2/p'`
    git_version_major=`echo $git_version | sed 's/^\([0-9]*\).*/\1/'`
    git_version_minor=`echo $git_version | sed 's/^[0-9]*\.\([0-9]*\).*/\1/'`
else
    git_version=
fi

if [ -n "$git_version" ]
then
    echo "Installing for git version $git_version"
    if [ $git_version_major -le 1 -a $git_version_minor -le 7 ] ; then
        # Git version 1.7 and below does not support the include config.
        # Get around this by making a symbolic link to the base configuration,
        # which should be valid for older versions of git.
        setup_symbolic_link "${HOME}/.gitconfig" "${KMOREL_CONFIG_DIR}/gitconfig/gitconfig.base"
    else
        echo "Looking for config file for git version $git_version"
        gitconfigfile="${KMOREL_CONFIG_DIR}/gitconfig/gitconfig.$git_version"
        while [ \! -f "$gitconfigfile" ] ; do
            if [ $git_version_minor -gt 0 ] ; then
                git_version_minor=`expr $git_version_minor - 1`
            else
                # It is pretty iffy to try to find the highest minor revision
                # of the next lower major revision. Just try 10 on down. This
                # might need changing later.
                git_version_minor=10
                git_version_major=`expr $git_version_major - 1`
            fi
            git_version=$git_version_major.$git_version_minor
            echo "... Trying for version $git_version"
            gitconfigfile="${KMOREL_CONFIG_DIR}/gitconfig/gitconfig.$git_version"
        done
        echo "Using git config file $gitconfigfile"
        case `uname` in
            CYGWIN*) setup_config_file "${HOME}/.gitconfig" "[include] path = $gitconfigfile" "[include] path = ${KMOREL_CONFIG_DIR}/gitconfig/gitconfig.win" ;;
            *) setup_config_file "${HOME}/.gitconfig" "[include] path = $gitconfigfile" ;;
        esac
        setup_config_file "${HOME}/.gitconfig" "[include] path = $gitconfigfile"
    fi
    setup_symbolic_link "${HOME}/.gitignore" "${KMOREL_CONFIG_DIR}/gitconfig/gitignore"
else
    echo "**** Could not get git version!!!!! ****"
    exit 1
fi

