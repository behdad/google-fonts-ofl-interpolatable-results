#! /bin/bash

dirname=$(dirname $0)
# If there are any arguments, use them as directories to search
# Otherwise, use the default directory
defaultdir=
if [ $# -eq 0 ]; then
	# No arguments supplied, using default directory
	defaultdir="$dirname/reports"
fi

# GitHub doesn't like us making too many requests too quickly.
# So, no parallelizing, and sleep in between.
find $defaultdir "$@" -name '*.ttf.metadata' |
xargs --verbose -I {} $dirname/report-one.sh --sleep "{}"
