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

cores=`grep -c ^processor /proc/cpuinfo`
echo "Cranking up $cores report-one.sh processes at a time"
find $defaultdir "$@" -name '*.ttf.metadata' |
xargs --verbose -P "$cores" -I {} $basedir/report-one.sh "{}"
