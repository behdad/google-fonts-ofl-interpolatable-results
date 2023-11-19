#! /bin/bash

dir=$1
clear=false
if [ -z "$dir" ]; then
  dir=~/google-fonts/ofl
  clear=true
fi
out=$2
if [ -z "$out" ]; then
  out=reports/
fi

mkdir -p $out &&
time find $dir -name '*\[*.ttf' -print0 |
  xargs --verbose -0 -P 24 -I{} \
  fonttools varLib.interpolatable "{}" --pdf "{}".pdf --output "{}".txt

if $clear; then
  echo "Clearing $out"
  rm -f $out/*.ttf.{pdf,txt}
fi

echo "Moving reports to $out"
find $dir \( -name '*.ttf.pdf' -o -name '*.ttf.txt' \) -print0 |
  xargs -0 -I{} mv {} $out

echo "Removing empty reports"
find $out -name '*.ttf.txt' -size 0 |
  while read x; do rm -f "$x" "${x%txt}pdf"; done
