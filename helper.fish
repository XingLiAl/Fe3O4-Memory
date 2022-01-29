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

function preview
    hugo server --gc --minify --cleanDestinationDir --i18n-warnings
end

function publish
    read msg
    # publish source
    git add .
    git commit -m $msg
    git push origin master
    # compile
    hugo --gc --minify --cleanDestinationDir --i18n-warnings
    echo www.fe3o4.top > CNAME
    # publish site
    cd public
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
    case preview
        preview
    case publish
        publish
    case "*"
        echo Do it yourself plz
end
