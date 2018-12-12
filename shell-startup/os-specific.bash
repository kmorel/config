#!/bin/bash

# Sets up os-specific environment.  First detects what type of OS we are
# running on and then sets up that environment accordingly.  This script
# can be sourced by bash and zsh.

case `uname` in

    Darwin)
	stty erase '^?'

	alias ldd='otool -L'

        # Disable ReportCrash application
	launchctl unload \
	    /System/Library/LaunchDaemons/com.apple.ReportCrash.plist \
	    >& /dev/null

	# Macports setup
	add_before_system_path \
	    /opt/local/bin \
	    /opt/local/sbin
	export MANPATH=/opt/local/share/man:`man -w`
        # sudo to root, establish http proxy, and run port command.
	alias sudoport='sudo env http_proxy=$http_proxy port'

        # This is a hack to get completions to work in git repositories.  I
        # wonder if it will ever get fixed.
	add_after_system_path /opt/local/libexec/git-core

	# Trick using file associations to open web pages.
	export BROWSER=open

	# Use emacsclient on Mac instead of gnuclient
	alias e='/Applications/MacPorts/Emacs.app/Contents/MacOS/bin/emacsclient --create-frame --no-wait'
	alias emacsclient='/Applications/MacPorts/Emacs.app/Contents/MacOS/bin/emacsclient'

	# Aliases to enable/disable capturing the drop shadow of windows in
	# screen captures
	alias screencapture-disable-shadow='defaults write com.apple.screencapture disable-shadow -bool true && killall SystemUIServer'
	alias screencapture-enable-shadow='defaults write com.apple.screencapture disable-shadow -bool false && killall SystemUIServer'
	;;

    CYGWIN*)
	alias open='cmd /c start'

	# Use emacsclient on Mac instead of gnuclient
	alias e='emacsclient --create-frame --no-wait'

	# Start something in a command prompt window. Responds to breaks better
	alias cmdwindow='cmd /c start cmd /c'

	# Start Jekyll server in the current directory
	alias jekyll-serve='cmdwindow bundle exec jekyll serve'

	# On Cygwin, the DISPLAY defaults to :0 or :0.0. That work fine
	# for local connections but seems to fail when forwarding X over
	# ssh. Changing DISPLAY to localhost:0 or localhost:0.0 works.
	if echo $DISPLAY | grep '^:' > /dev/null; then
	    export DISPLAY=localhost$DISPLAY
	fi
	;;

esac
