#! /bin/bash

dirname=`dirname $0`
ttf=$1
basename=`basename $ttf`
out="$dirname/reports/$basename"

"$dirname"/submodules/fonttools/fonttools varLib.interpolatable \
	"$ttf" \
	--pdf "$out.pdf" \
	--html "$out.html" \
	--output "$out.txt"
status=$?
bzip2 < "$out.html" > "$out.html.bz2" && rm "$out.html"
echo "Finished all with '$ttf'"
exit $status
