#! /bin/bash

dirname=`dirname $0`
cd "$dirname/reports"

git diff HEAD | diffstat | grep -q binary &&
yes |
git difftool --tool=ttf-html-xz HEAD \
	$(git diff HEAD *.ttf.html.xz | diffstat | grep binary | cut -d' ' -f2)
