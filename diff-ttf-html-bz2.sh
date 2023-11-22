#! /bin/bash

dirname=`dirname "$0"`
basename=`basename "$3" .html.bz2`

dir=`mktemp -d`

echo "Uncompressing $1 and $2 to $dir"
bunzip2 -c "$1" > "$dir/1.html"
bunzip2 -c "$2" > "$dir/2.html"

echo "Diffing $dir/1.html and $dir/2.html to $dir/diff.html"
"$dirname/html-diff.sh" --title "$basename diff" "$dir/1.html" "$dir/2.html" > "$dir/$basename-diff.html"

rm -f "$dir/1.html" "$dir/2.html"

xdg-open "$dir/$basename-diff.html"
