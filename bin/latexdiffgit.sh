#!/bin/bash

usage() {
    echo "USAGE: $0 [options] GIT-COMMIT"
    echo
    echo "[options] are passed directly to latexdiff. See 'latexdiff -h' for"
    echo "information on those options."
    echo
    echo "GIT-COMMIT must reference a valid commit in the current repo."
    echo
    exit 1
}

if [ $# -lt 1 ] ; then
    usage
fi

latexdiff_args=
last_arg=
for arg in "$@" ; do
    if [ $arg = "-h" ] ; then
	usage
    fi
    latexdiff_args="$latexdiff_args $last_arg"
    last_arg="$arg"
done

commit=$last_arg

# Check that we are being run in a proper git repo
if git rev-parse --is-inside-work-tree >& /dev/null ; then
    :
else
    echo "ERROR: $0 must be run from within a git repository."
    exit 1
fi

# Check that the commit we were given is valid
if git rev-parse --quiet --verify $commit^{commit} > /dev/null ; then
    echo "Producing diff against commit $commit"
else
    echo "ERROR: Commit $commit does not exist! Aborting!"
    exit 1
fi

# Check that the current repo is clean
if [[ -n $(git status -s) ]] ; then
    echo "Uncommitted or unmodified files detected in current repo!"
    echo "This script is going to make some changes to the files in the repo"
    echo "that you probably do not want to keep. Thus, we only allow this to"
    echo "be run on a clean repo directory so that a simple 'git reset --hard'"
    echo "can restore the directory."
    exit 1
fi

for tex_file in `git ls-files \*.tex` ; do
    echo -n "$tex_file..."
    # Get old version of file
    if git cat-file -e $commit:$tex_file >& /dev/null ; then
	git cat-file blob $commit:$tex_file > $tex_file-old
    else
	# If the new file has a preamble, then the new one has to have
	# one, too. Pull enough to "generate" one.
	grep '\(\\documentclass\)\|\(\\begin{document}\)\|\(\\end{document}\)' \
	     $tex_file > $tex_file-old
    fi
    # Move new version of file
    mv $tex_file $tex_file-new
    # Do the diff
    latexdiff $latexdiff_args $tex_file-old $tex_file-new > $tex_file
    # Remove temporary files
    rm $tex_file-old $tex_file-new
    echo "OK"
done
