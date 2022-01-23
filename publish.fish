#!/bin/fish

# publish source
git add .
git commit -m "$argv"
#git push origin master
hugo --minify
cd public
git add .
git commit -m "$argv"
#git push origin master
