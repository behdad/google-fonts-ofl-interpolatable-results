#! /bin/bash

dirname=$(dirname "$0")

defaultdir=
if [ $# -eq 0 ]; then
	# No arguments supplied, using default directory
	defaultdir="$dirname/reports"
fi

# GitHub doesn't like us making too many requests too quickly.
# So, no parallelizing.
find $defaultdir "$@" -name '*.ttf.issue' |
while read x; do
	raw_url=`cat "$x"`
	# Drop a possible initial "#" from the issue number
	url=${raw_url#\#}
	echo -n "$raw_url " && gh issue view --json state --jq '.state' $url | cat
done
