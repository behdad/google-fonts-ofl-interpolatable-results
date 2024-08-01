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
[difftool "ttf-html-xz"]
   cmd = ~/google-fonts-ofl-interpolatable-results/diff-ttf-html-xz.sh \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
```
(update the directory path as you wish.)

And then in `~/.gitattributes`:
```
*.ttf.html.xz diff=diff-ttf-html-xz
```

This way, you can use eg.:
```
$ ./review-one reports/FamilyName.html.xz
```

To open *all* the changed HTML files in your browser (at your own risk),
do:
```
$ ./review-all
```
