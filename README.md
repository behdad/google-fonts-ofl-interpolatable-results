## Intro

This repository holds reports of the `fonttools varLib.interpolatable`
tool on the Google Fonts catalog.

## Update

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
