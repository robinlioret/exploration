#!/bin/bash
# Format all the terraform repository found.

declare -a DIRECTORIES
find . -name "*.tf" | while read line; do
    DIRECTORY="$(dirname "$line")"
    if [[ ! ${DIRECTORIES[@]} =~ $DIRECTORY ]]; then
        DIRECTORIES+=($DIRECTORY)

        echo "Formatting $DIRECTORY"
        (cd $DIRECTORY && terraform fmt)
    fi
done