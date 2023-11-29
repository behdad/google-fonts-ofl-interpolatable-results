#! /bin/bash

dirname=$(dirname $0)
# If there are any arguments, use them as directories to search
# Otherwise, use the default directory
defaultfiles=
if [ $# -eq 0 ]; then
	# No arguments supplied, using default directory
	defaultfiles=$dirname/reports/*.html.bz2
fi

$(git diff HEAD $defaultfiles "$@" | diffstat | grep -q binary) &&
yes |
git difftool --tool=ttf-html-bz2 HEAD \
	$(git diff HEAD $defaultfiles "$@" | diffstat | grep binary | cut -d' ' -f2)
