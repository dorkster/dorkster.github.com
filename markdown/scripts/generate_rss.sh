#!/bin/bash

# this script generates an rss feed for the blog
cd ~/Projects/dorkster.github.com/markdown/

RSSFILE="blog.rss"

echo "Generating ../$RSSFILE"
PAGEDESC=""
PAGEIMG=""

echo "<?xml version=\"1.0\"?>" > "../$RSSFILE"

echo "<rss version=\"2.0\">" >> "../$RSSFILE"
echo "<channel>" >> "../$RSSFILE"
echo "<title>dorkster - Blog</title>" >> "../$RSSFILE"
echo "<link>http://dorkster.github.io/blog_page0.html</link>" >> "../$RSSFILE"
echo "<description></description>" >> "../$RSSFILE"

for i in $(ls -1 blog/*.md | sort -r); do
    # this assumes that pages start with "## PAGETITLE"
    PAGETITLE=$(head -n 1 $i | cut -c 4-)

    PAGEDESC="$(sed -n '3p' $i | sed -e 's/[\/&]/\\&/g' | \grep -P -o '.*?[\.\?\!]\s' | sed 1q | sed -e 's/\s$//g')"
    if [ -z "$PAGEDESC" ]; then
        PAGEDESC="$(sed -n '3p' $i | sed -e 's/[\/&]/\\&/g' | \grep -P -o '.*?[\.\?\!]' | sed 1q)"
        if [ "$PAGEDESC" == "!" ];then PAGEDESC="";fi
    fi

    # permalink to blog post
    ARCHIVEFILE="blog_$(basename $i ".md").html"

    echo "<item>" >> "../$RSSFILE"
    echo "<title>$PAGETITLE</title>" >> "../$RSSFILE"
    echo "<link>http://dorkster.github.io/$ARCHIVEFILE</link>" >> "../$RSSFILE"
    echo "<description>$PAGEDESC</description>" >> "../$RSSFILE"
    echo "</item>" >> "../$RSSFILE"

done

echo "</channel>" >> "../$RSSFILE"
echo "</rss>" >> "../$RSSFILE"

