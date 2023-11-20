#! /bin/bash

echo "<!DOCTYPE html>"
echo "<html><body align=center>"

if [ $# -lt 2 ]; then
	echo "Usage: $0 <old-file>.html <new-file>.html"
	exit 1
fi

if [ "$1" = "--title" ]; then
	echo "<h1>$2</h1>"
	shift 2
fi

diff \
	--unchanged-line-format='' \
	--old-line-format='<div style="background: #F88">%L</div>' \
	--new-line-format='<div style="background: #8F8">%L</div>' \
	"$@"
echo "</body></html>"
