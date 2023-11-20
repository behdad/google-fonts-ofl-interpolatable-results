#! /bin/bash

dirname=$(dirname "$0")
dir=$1
clear=false
if [ -z "$dir" ]; then
  dir="$dirname/submodules/google-fonts/ofl"
  clear=true
fi
out=$2
if [ -z "$out" ]; then
  out="$dirname/reports/"
fi

git submodule init
(cd "$dirname/submodules/google-fonts" && time git pull)
(cd "$dirname/submodules/fonttools" && time git pull)
(cd "$dirname/submodules/fonttools" && time python setup.py build_ext -i)

time find "$dir" -name '*\[*.ttf' -print |
  xargs ls --sort=size |
  xargs --verbose -P 24 -I{} \
  submodules/fonttools/fonttools varLib.interpolatable "{}" --pdf "{}".pdf --html "{}".html --output "{}".txt

if $clear; then
  echo "Clearing $out"
  time rm -f $out/*.ttf.{pdf,html,txt}
fi

echo "Moving reports to $out"
time find $dir \( -name '*.ttf.pdf' -o -name '*.ttf.html' -o -name '*.ttf.txt' \) -print0 |
  xargs -0 -I{} mv {} "$out"

echo "Removing empty reports"
time find "$out" -name '*.ttf.txt' -size 0 |
  while read x; do rm -f "$x" "${x%txt}pdf" "${x%txt}html"; done

echo "Gzipping the HTML reports"
time find "$out" -name '*.ttf.html' |
  while read x; do gzip -f "$x"; done
