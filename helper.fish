#!/bin/fish

function init
    # get submodule
    git submodule update --init --recursive
    # get public
    cd public
    git clone git@github.com:Fe3O4-Git/Fe3O4-Git.github.io.git
end

function update
    # update submodule
    git submodule update --remote --merge
end

function publish
    read msg
    # publish source
    git add .
    git commit -m $msg
    git push origin master
    # compile
    hugo --minify
    # publish site
    cd public
    ls
    git add .
    git commit -m $msg
    git push origin master
end

# entry
switch $argv[1]
    case ""
        echo What a nice day caz there\'s nothing to do
    case init
        init
    case update
        update
    case publish
        publish
    case "*"
        echo Do it yourself plz
end
