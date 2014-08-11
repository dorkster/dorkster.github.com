#!/bin/bash

# this script generates the pagers for blog articles, as well as the blog articles themselves
cd ~/Projects/dorkster.github.com/markdown/

# first, delete the old generated files
rm -f ../index.html
rm -f ../blog*.html

PAGERFILE="index.html"

BLOGINDEX=1
BLOGMAXINDEX=5
BLOGTOTAL=$(ls -1 blog/*.md | wc -l)

PAGEINDEX=1
PAGEPREV=""
PAGENEXT="blog_page$PAGEINDEX.html"

echo "Generating ../$PAGERFILE"
cat html_template/header.txt | sed -e "s/PAGETITLE/Blog/g" > "../$PAGERFILE"

for i in $(ls -1 blog/*.md | sort -r); do
    # this assumes that pages start with "## PAGETITLE"
    PAGETITLE=$(head -n 1 $i | cut -c 4- | sed -e 's/\//\\\//g')

    HTMLFILE="blog_$(basename $i ".md").html"
    echo "Generating ../$HTMLFILE"
    cat html_template/header.txt | sed -e "s/PAGETITLE/$PAGETITLE/g" > "../$HTMLFILE"
    echo "<div class=\"blogpost\">" >> "../$HTMLFILE"
    markdown $i >> "../$HTMLFILE"
    echo "</div>" >> "../$HTMLFILE"
    cat html_template/footer.txt >> "../$HTMLFILE"

    echo "<div class=\"blogpost\">" >> "../$PAGERFILE"
    markdown $i >> "../$PAGERFILE"
    echo "<p><a href=\"$HTMLFILE\">Permalink</a></p>" >> "../$PAGERFILE"
    echo "</div>" >> "../$PAGERFILE"

    if [ $(expr $BLOGINDEX % $BLOGMAXINDEX) -eq 0 ] || [ $BLOGINDEX -eq $BLOGTOTAL ]; then
        echo "<p>" >> "../$PAGERFILE"
        if [ -n "$PAGEPREV" ]; then
            echo "<a href=\"$PAGEPREV\">Newer entries</a>" >> "../$PAGERFILE"
        fi
        if [ $BLOGINDEX -lt $BLOGTOTAL ]; then
            if [ -n "$PAGEPREV" ] && [ -n "$PAGENEXT" ]; then
                echo " | " >> "../$PAGERFILE"
            fi
            if [ -n "$PAGENEXT" ]; then
                echo "<a href=\"$PAGENEXT\">Older entries</a>" >> "../$PAGERFILE"
            fi

            echo "</p>" >> "../$PAGERFILE"
            cat html_template/footer.txt >> "../$PAGERFILE"

            PAGEPREV="$PAGERFILE"
            PAGERFILE="$PAGENEXT"
            let "PAGEINDEX++"
            PAGENEXT="blog_page$PAGEINDEX.html"

            echo "Generating ../$PAGERFILE"
            cat html_template/header.txt | sed -e "s/PAGETITLE/Blog/g" > "../$PAGERFILE"
        else
            echo "</p>" >> "../$PAGERFILE"
        fi
    fi

    let "BLOGINDEX++"

done

cat html_template/footer.txt >> "../$PAGERFILE"
