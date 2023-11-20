#! /bin/bash

dirname=`dirname $0`
ttf=$1
basename=`basename $ttf`
out="$dirname/reports/$basename"

"$dirname"/submodules/fonttools/fonttools varLib.interpolatable \
	"$ttf" \
	--pdf "$out.pdf" \
	--html "$out.html" \
	--output "$out.txt" &&
bzip2 < "$out.html" > "$out.html.bz2"
status=$?
echo "Done processing $ttf"
exit $status
