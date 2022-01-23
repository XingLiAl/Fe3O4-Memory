#!/bin/fish

# get submodule
git submodule update --init --recursive

# get public
cd public
git clone git@github.com:Fe3O4-Git/Fe3O4-Git.github.io.git
