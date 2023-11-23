#! /bin/bash

basedir=$(dirname $0)
cd "$basedir"
# If there are any arguments, use them as directories to search
# Otherwise, use the default directory
defaultdir=
if [ $# -eq 0 ]; then
	# No arguments supplied, using default directory
	defaultdir=reports
fi

# GitHub doesn't like us making too many requests too quickly.
# So, no parallelizing, and sleep in between.
find $defaultdir "$@" -name '*.ttf.metadata' |
xargs --verbose -I {} $basedir/report-one.sh --sleep "{}"
