#! /bin/bash

dirname=`dirname "$0"`
basename=`basename "$3" .html.bz2`

dir=`mktemp -d`

before="$dir/$basename.before.html"
after="$dir/$basename.after.html"

echo "Uncompressing $1 and $2 to $dir"
bunzip2 -c "$1" > "$before"
bunzip2 -c "$2" > "$after"

echo "Diffing $dir/1.html and $dir/2.html to $dir/diff.html"
"$dirname/html-diff.sh" --title "$basename diff" "$before" "$after" > "$dir/$basename-diff.html"

rm -f "$before" "$after"

open=xdg-open
if ! which $open >/dev/null; then
	# Mac
	open=open
fi

$open "$dir/$basename-diff.html"
