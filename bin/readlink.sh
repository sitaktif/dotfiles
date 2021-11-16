#!/bin/bash

set -eu

my_readlink() {
    # Resolve the file then resolve the path
    local file=$1
    local dir
    local oldcwd=$(pwd -P)
    while [[ -L $file ]]; do
        dir="$(dirname "$file")"
        file=$(/usr/bin/readlink "$file")
        cd "$dir"
    done
    echo "$(pwd -P)/$(basename "$file")"
    cd "$oldcwd"
}


my_readlink "$1"
greadlink -f "$1"
