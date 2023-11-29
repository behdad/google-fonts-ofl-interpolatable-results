#! /bin/bash

dirname=`dirname $0`
cd "$dirname/reports"

git diff HEAD | diffstat | grep -q binary &&
yes |
git difftool --tool=ttf-html-bz2 HEAD \
	$(git diff HEAD *.ttf.html.bz2 | diffstat | grep binary | cut -d' ' -f2)
