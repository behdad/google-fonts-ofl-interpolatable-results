#! /bin/bash

if [ $# -lt 2 ]; then
	echo "Usage: $0 <old-file>.html <new-file>.html"
	exit 1
fi

if [ "$1" = "--title" ]; then
	echo "<h1>$2</h1>"
	shift 2
fi

echo "<!DOCTYPE html>"
echo "<html><body align=center>"

diff=diff
test=`$diff --unchanged-line-format='' /dev/null /dev/null`
if [ x$? != x0 ]; then
	if [ -f /opt/homebrew/bin/diff ]; then
		diff=/opt/homebrew/bin/diff
	else
		echo "GNU diff not found; if on Mac, try 'brew install diffutils'"
		exit 1
	fi
fi


# Diffing twice; oh well. Maybe write the second as a sed...

echo '<pre style="font-size: 150%">'
$diff "$@" | diffstat | sed 's/unknown *| *//; s/\(\+*\)\(-*\)$/<span style="color: #0B0">\1<\/span><span style="color: #B00">\2<\/span>/'
echo '</pre>'

$diff \
	--unchanged-line-format='' \
	--old-line-format='<div style="background: #F88">%L</div>' \
	--new-line-format='<div style="background: #8F8">%L</div>' \
	"$@"

echo "</body></html>"
