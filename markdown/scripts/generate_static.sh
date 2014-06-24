#!/bin/bash

# this script generates Projects, About, etc.
cd ~/Projects/dorkster.github.com/markdown/

for i in *.md; do
    # this assumes that pages start with "## PAGETITLE"
    PAGETITLE=$(head -n 1 $i | cut -c 4- | sed -e 's/\//\\\//g')

    HTMLFILE="../$(basename $i ".md").html"
    echo "Generating $HTMLFILE"
    cat html_template/header.txt | sed -e "s/PAGETITLE/$PAGETITLE/g" > "$HTMLFILE"
    markdown $i >> "$HTMLFILE"
    cat html_template/footer.txt >> "$HTMLFILE"
done
