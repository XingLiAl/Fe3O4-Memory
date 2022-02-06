#!/bin/fish

function init
    git submodule update --init --recursive
    cd public
    git clone git@github.com:Fe3O4-Git/Fe3O4-Git.github.io.git
end

function update
    git submodule update --remote --merge
end

function new
    read name -p "echo Enter new post name:"
    set path "posts/"$name".md"
    hugo new $path
    kate "content/"$path
end

function server
    xdg-open http://localhost:1313
    hugo server -D --i18n-warnings
end

function compile
    read msg -p "echo Enter commit message:"
    git add .
    git commit -m $msg
    hugo --gc --minify --cleanDestinationDir --i18n-warnings
    cd public
    git add .
    git commit -m $msg
end

function publish
    git push origin master
    cd public
    git push origin master
end

switch $argv[1]
    case init
    case i
        init
    case update
    case u
        update
    case new
    case n
        new
    case server
    case s
        server
    case compile
    case c
        compile
    case publish
    case p
        publish
    case "*"
        cat ./helper_of_helper.txt
end
