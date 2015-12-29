#!/bin/bash

# this script generates the pagers for blog articles, as well as the blog articles themselves
cd ~/Projects/dorkster.github.com/markdown/

HTMLFILE="blog_archive.html"

echo "Generating ../$HTMLFILE"
PAGEDESC=""
PAGEIMG=""
cat html_template/header.txt | sed -e "s/PAGETITLE/Blog Archive/g" -e "s/PAGEDESC/$PAGEDESC/g" -e "s/PAGEIMG/$PAGEIMG/g" > "../$HTMLFILE"

# highlight the "Blog Archive" link in nav
CURRENT=$(sed -n "/$HTMLFILE/=" ../$HTMLFILE | head -n1)
if [ $CURRENT ]; then
    sed -i -e ""$CURRENT"s/<a /<a class=\"current\" /" "../$HTMLFILE"
    CURRENT=""
fi

echo "<div class=\"static\">" >> "../$HTMLFILE"
echo "<h2>Blog Archive</h2>" >> "../$HTMLFILE"
echo "<ul>" >> "../$HTMLFILE"

for i in $(ls -1 blog/*.md | sort -r); do
    # this assumes that pages start with "## PAGETITLE"
    PAGETITLE=$(head -n 1 $i | cut -c 4-)

    # permalink to blog post
    ARCHIVEFILE="blog_$(basename $i ".md").html"

    # insert the current blog post onto the current blog archive page
    echo "<li><a href=\"$ARCHIVEFILE\">$PAGETITLE</a></li>" >> "../$HTMLFILE"

done

echo "</ul>" >> "../$HTMLFILE"
echo "</div>" >> "../$HTMLFILE"
cat html_template/footer.txt >> "../$HTMLFILE"

