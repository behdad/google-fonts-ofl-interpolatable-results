#! /bin/bash

for cmd in curl jq gh; do
	if ! which $cmd >/dev/null; then
		echo "ERROR: $cmd not found"
		exit 1
	fi
done

sleep=0
dryrun=false
while [ $# -gt 0 ]; do
	case "$1" in
	--sleep)
		sleep=1
		;;
	--dry-run)
		dryrun=true
		;;
	*)
		break
		;;
	esac
	shift
done

our_repo=https://github.com/behdad/google-fonts-ofl-interpolatable-results

dirname=$(dirname "$1")
basename=$(basename "$1" .metadata)

# Check that basename ends in ttf
metadata=$"$dirname/$basename.metadata"
if [ ! -f "$metadata" ]; then
	echo "ERROR: No metadata file found: $basename.metadata"
	exit 1
fi
reportfile="$dirname/$basename.txt"
if [ ! -f "$reportfile" ]; then
	echo "ERROR: No report file found: $basename.txt"
	exit 1
fi
if [ ! -f "$dirname/$basename.pdf" ]; then
	echo "ERROR: No PDF file found: $basename.pdf"
	exit 1
fi

if [ -f "$dirname/$basename.issue" -a x$dryrun = xfalse ]; then
	echo "INFO: Issue already filed: $(cat "$dirname/$basename.issue")"
	exit 1
fi

archive_url=$(cat $metadata | grep '^archive_url:' | tail -n 1 | cut -d' ' -f2 | sed -e 's/"//g')
if [ "x$archive_url" = xarchive_url: ]; then
  archive_url=""
fi
if [ "x$archive_url" = x ]; then
	archive_url=$(cat "$metadata" | grep '^archive:' | tail -n 1 | cut -d' ' -f2)
	if [ "x$archive_url" = xarchive: ]; then
	  archive_url=""
	fi
fi

repository_url=$(cat "$metadata" | grep '^repository_url:' | tail -n 1 | cut -d' ' -f2 | sed -e 's/"//g')
if [ "x$repository_url" = xrepository_url: ]; then
	repository_url=""
fi
if [ "x$repository_url" = x ]; then
	repository_url=$(cat "$metadata" | grep '^contribution_url:' | tail -n 1 | cut -d' ' -f2 | sed -e 's/"//g')
	if [ "x$repository_url" = xrepository_url: ]; then
		repository_url=""
	fi
fi
if [ "x$repository_url" = x ]; then
	# If archive_url is github, extract the repo URL from it
	# For example, if archive_url is https://github.com/googlefonts/roboto-flex/releases/download/3.100/roboto-flex-fonts.zip
	# then we just want https://github.com/googlefonts/roboto-flex
	repository_url=$(echo "$archive_url" | sed -e 's/\/releases\/download\/.*//')
	if [ "x$repository_url" = "x$archive_url" ]; then
		# If archive_url is not github, then we don't know how to get the repo URL
		repository_url=""
	fi
fi
if [ "x$repository_url" = x ]; then
	# Bail
	echo "WARNING: Could not determine repository URL"
	exit 1
fi
# Check that we have a repository URL that starts with https://github.com/
if [ x"$repository_url" = "${repository_url%https://github.com/}" ]; then
	echo "INFO: Repository URL does not point to GitHub: $repository_url"
	exit 1
fi

report="$(cat "$reportfile")"
if [ "x$report" = x ]; then
	echo "INFO: No problems found in the report: $basename.txt"
	exit 1
fi

# Get our own git revision
git_rev=$(git rev-parse HEAD)
# URL-encode it using jq!
basename_encoded=$(echo -n "$basename" | jq -sRr @uri)
pdf_url="$our_repo/raw/$git_rev/reports/$basename_encoded.pdf"
pdfviewer_url="$our_repo/blob/$git_rev/reports/$basename_encoded.pdf"
# Double-check that the file exists
curl -I "$pdf_url" 2>/dev/null | head -n 1 | grep -q '^HTTP/.* [23]0[0-9]'
if [ $? -ne 0 ]; then
	echo "ERROR: Could not find PDF report at $pdf_url; did you push?"
	exit 1
fi

# Finally! Assemble the text.

title="Interpolation problems in \`$basename\`"
body="
Hello!

This is an automatically-generated report about possible interpolation problems in \`$basename\`, as found in the Google Fonts catalog.
"
if [ x"$archive_url" != x ]; then
	archive_basename=$(echo "$archive_url" | sed 's@.*/releases/download/@@')
	body="$body
The particular version of the font that was tested was [$archive_basename]($archive_url).
"
fi

body="$body
To download a PDF version of this report with helpful visuals of the problems, click [here]($pdf_url); Or to view it on the GitHub website, click [here]($pdfviewer_url).
"

body="$body
The report follows:
\`\`\`
$report
\`\`\`
"

body="$body
This report was generated using the \`fonttools varLib.interpolatable\` tool.  We understand that sometimes the tool generates false-positives.  Particularly for more complicated font designs.  If you did not find this report useful, please accept our apologies and ignore / close it.

To give feedback about this report, please file an issue or open a discussion at [fonttools](https://github.com/fonttools/fonttools).

Please note that I am doing this as a community service and do not represent Google Fonts.
"

if $dryrun; then
	echo "Dry-run mode.  Would have filed the following issue:"
	echo "Title: $title"
	echo "Body:"
	echo "$body"
	exit 0
fi
# Okay! File it!
issue_url=$(gh issue create \
	--title "$title" \
	--body "$body" \
	--repo "$repository_url" | tail -n 1)
if [ -x"$issue_url" = -x ]; then
	echo "ERROR: Could not file issue at $repository_url"
	exit 1
fi
echo "$issue_url" | tee "$dirname/$basename.issue"
# Done! Sleep time!
sleep $sleep
