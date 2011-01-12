#!/bin/bash

# Sets up environment for particular development projects I am working on.
# These settings should be considered temporary (changed whenever the
# development changes or I move on to other projects).  This script can be
# sourced by bash and zsh.

# For debugging tiled displays in ParaView.  Keeps the windows from being
# full screen.
export PV_ICET_WINDOW_BORDERS=1

# This tells Mac OSX to use the debug version of libraries when they are 
# available.
#export DYLD_IMAGE_SUFFIX=_debug
