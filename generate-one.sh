#! /bin/bash

clean=false
while [ $# -gt 0 ]; do
	case "$1" in
	--clean)
		clean=true
		;;
	*)
		break
		;;
	esac
	shift
done

dirname=`dirname $0`
ttf=$1
basename=`basename $ttf`
out="$dirname/reports/$basename"

echo "Processing '$ttf'"

basebasename="$(echo "$basename" | sed 's/\[.*$//')"
if grep -q "^$basebasename\$" "$dirname/IGNORE.txt"; then
	echo "Ignoring   '$ttf'"
	exit 0
fi

"$dirname"/submodules/fonttools/fonttools varLib.interpolatable \
	"$ttf" \
	--pdf "$out.pdf" \
	--html "$out.html" \
	--output "$out.txt"
status=$?

if [ x$clean = xtrue -a x$status = x0 ]; then
	rm "$out.pdf" "$out.html" "$out.txt"
	echo "Cleaned up '$ttf'"
	exit $status
fi

xz -3 < "$out.html" > "$out.html.xz" && rm "$out.html"

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


echo "Dirtied up '$ttf'"
exit $status
