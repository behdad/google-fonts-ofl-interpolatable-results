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

# See if we can find the source info for the font and save it.
ttfdirname=`dirname "$ttf"`
metadata="$ttfdirname/METADATA.pb"
upstream="$ttfdirname/upstream.yaml"
> "$out.metadata"
if [ -f "$metadata" ]; then
	grep _url "$metadata" | sed 's/^ *//' >> "$out.metadata"
fi
if [ -f "$upstream" ]; then
	grep "^archive\|^branch" "$upstream" >> "$out.metadata"
fi

echo "Finished all with '$ttf'"
exit $status
