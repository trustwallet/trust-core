#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

find . -name '*.gyb' |                                               \
    while read file; do                                              \
        "$DIR/gyb" --line-directive '' -o "${file%.gyb}" "$file"; \
    done
