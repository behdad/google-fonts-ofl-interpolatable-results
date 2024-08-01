#! /bin/bash

echo "Making one with everything."

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

echo "Building fonttools cython extensions"
(cd "$dirname/submodules/fonttools" && time python3 setup.py build_ext -i)

if $clear; then
  echo "Clearing $out"
  time rm -f "$out"/*.ttf.{pdf,html.xz,txt,metadata}
fi

sort=--sort=size
ls $sort /dev/null 2>/dev/null >/dev/null
if [ x$? != x0 ]; then
	sort=
fi

if [ -f /proc/cpuinfo ]; then
	cores=`grep -c ^processor /proc/cpuinfo`
else
	cores=`sysctl -n hw.ncpu`
fi

echo "Cranking up $cores generate-one.sh processes at a time"
time find "$dir" -name '*\[*.ttf' -print |
  xargs ls $sort |
  xargs -P "$cores" -I{} \
  "$dirname/generate-one.sh" --clean "{}"
