#! /bin/bash

commit=HEAD
while [ $# -gt 0 ]; do
	case "$1" in
	--commit)
		commit=$2
		shift
		;;
	*)
		break
		;;
	esac
	shift
done

yes |
git difftool --tool=ttf-html-bz2 "$commit" "$@"
