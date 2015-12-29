#!/bin/bash

# this script generates the navigation menu used on all pages
cd ~/Projects/dorkster.github.com/markdown/

NAVFILE="html_template/nav.txt"

BLOGINDEX=1
BLOGMAXINDEX=100

echo "<li><a href=\"index.html\">About</a></li>" > $NAVFILE

for i in *.md; do
    if [ "$i" == "index.md" ]; then
        continue
    fi

    # this assumes that pages start with "## PAGETITLE"
    PAGETITLE=$(head -n 1 $i | cut -c 4-)

    HTMLFILE="$(basename $i ".md").html"
    echo "<li><a href=\"$HTMLFILE\">$PAGETITLE</a></li>" >> $NAVFILE
done

echo "<li><a href=\"blog_page0.html\">Latest Blog Posts</a></li>" >> $NAVFILE
echo "<li><a href=\"blog_archive.html\">Blog Archive</a></li>" >> $NAVFILE

# put it all together
cat html_template/header1.txt html_template/nav.txt html_template/header2.txt > html_template/header.txt

