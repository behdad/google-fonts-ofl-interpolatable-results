## Intro

This repository holds reports of the `fonttools varLib.interpolatable`
tool on the Google Fonts catalog.  The tools here work on Linux, as
well as Mac with brew.

## Update

For the first time, you would need to run
```
$ git submodule update
```
to download and populate `submodules/fonttools` and `submodules/google-fonts`.
This might take a while.

To update all reports, run `./generate-all.sh`.

## git setup

To get a visual diff of the changes, you can configure `git` as below:

- Put in your `~/.gitconfig`:
```
[core]
    attributesfile = ~/.gitattributes
```
and
```
[difftool "ttf-html-bz2"]
   cmd = ~/google-fonts-ofl-interpolatable-results/diff-ttf-html-bz2.sh \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
```
(update the directory path as you wish.)

And then in `~/.gitattributes`:
```
*.ttf.html.bz2 diff=diff-ttf-html-bz2
```

This way, you can use eg.:
```
$ git difftool --tool=ttf-html-bz2 reports/*.html.bz2
```

Read `man git-difftool` for other options.

To open *all* the changed HTML files in your browser (at your own risk),
do:
```
$ ./review-all
```
