#! /bin/bash

dirname=`dirname $0`
ttf=$1
basename=`basename $ttf`
out="$dirname/reports/$basename"

basebasename="$(echo "$basename" | sed 's/\[.*$//')"
if grep -q "^$basebasename\$" "$dirname/IGNORE.txt"; then
	echo "Ignoring '$ttf' as is in IGNORE.txt"
	exit 0
fi

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
description="$ttfdirname/DESCRIPTION.en_us.html"
> "$out.metadata"
if [ -f "$metadata" ]; then
	grep _url "$metadata" | sed 's/^ *//' >> "$out.metadata"
fi
if [ -f "$upstream" ]; then
	grep "^archive\|^branch" "$upstream" >> "$out.metadata"
fi
if [ -f "$description" ]; then
	grep '<a href="https://github.com/' "$description" | sed 's@.*<a href="\(https://github.com/[^"]*\)".*@contribution_url: \1@' >> "$out.metadata"
fi

echo "Finished all with '$ttf'"
exit $status
