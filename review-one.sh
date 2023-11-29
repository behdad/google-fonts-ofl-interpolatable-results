#! /bin/bash

yes |
git difftool --tool=ttf-html-bz2 HEAD "$@"
