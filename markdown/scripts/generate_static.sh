#!/bin/bash

# this script generates Projects, About, etc.
cd ~/Projects/dorkster.github.com/markdown/

PAGEDESC=""
PAGEIMG=""

for i in *.md; do
    if [ "$i" == "index.md" ]; then
        PAGETITLE="Home"
    else
        # this assumes that pages start with "## PAGETITLE"
        PAGETITLE=$(head -n 1 $i | cut -c 4- | sed -e 's/[\/&]/\\&/g')
    fi

    HTMLFILE="$(basename $i ".md").html"
    echo "Generating ../$HTMLFILE"
    cat html_template/header.txt | sed -e "s/PAGETITLE/$PAGETITLE/g" -e "s/PAGEDESC/$PAGEDESC/g" -e "s/PAGEIMG/$PAGEIMG/g" > "../$HTMLFILE"

    # highlight the matching page link in nav
    CURRENT=$(sed -n "/$HTMLFILE/=" ../$HTMLFILE | head -n1)
    if [ $CURRENT ]; then
        sed -i -e ""$CURRENT"s/<a /<a class=\"current\" /" "../$HTMLFILE"
        CURRENT=""
    fi

    echo "<div class=\"static\">" >> "../$HTMLFILE"
    markdown $i >> "../$HTMLFILE"
    echo "</div>" >> "../$HTMLFILE"
    cat html_template/footer.txt >> "../$HTMLFILE"
done
