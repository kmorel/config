#!/bin/zsh
# Setup file for zsh.  To use this file, add this to your .zshrc:
#
#    . ~/local/etc/config/zshrc.zsh
#
# or wherever you have stashed these files.  System specific configuration
# can also be added to your .zshrc before or after the call.
#

# Relative path to configure dir (the directory this script is located).
config_dir=$(dirname $0)

# Absolute path to configure dir
KMOREL_CONFIG_DIR=$("${config_dir}/bin/fullpath" "$config_dir")
export KMOREL_CONFIG_DIR
unset config_dir

. "$KMOREL_CONFIG_DIR/shell-startup/ls-setup.bash"

#Options
unsetopt AUTO_CD
unsetopt AUTO_PUSHD
unsetopt PUSHD_SILENT
unsetopt PUSHD_TO_HOME
setopt NO_BG_NICE
setopt NOTIFY

#############################################################################
# Set up key bindings.
bindkey -v			# Vi-like editing
bindkey "^A" beginning-of-line	# With some convienent emacs-like keys
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^D" delete-char-or-list

#############################################################################
# Load up colors.
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

#############################################################################
# Set up prompt.
PROMPT="%m %?> "
RPROMPT="${PR_RED}%~${PR_NO_COLOR}"

#############################################################################
# Set up completions
autoload -U compinit
if uname | fgrep CYGWIN > /dev/null ; then
    compinit -u
else
    compinit
fi

# Some customized completions
fpath=($KMOREL_CONFIG_DIR/zshfunc $fpath)
autoload -U $KMOREL_CONFIG_DIR/zshfunc/_*(:t)
