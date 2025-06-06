#!/bin/bash
# Format all the terraform repository found.

declare -a DIRECTORIES
find . -name "*.tf" | while read line; do
    DIRECTORY="$(dirname "$line")"
    [[ "$DIRECTORY" =~ ".terragrunt" ]] && continue
    if [[ ! ${DIRECTORIES[@]} =~ $DIRECTORY ]]; then
        DIRECTORIES+=($DIRECTORY)

        echo "Formatting $DIRECTORY"
        (cd $DIRECTORY && terraform fmt)
    fi
done

declare -a DIRECTORIES
find . -name "*.hcl" | while read line; do 
    DIRECTORY="$(dirname "$line")"
    [[ "$DIRECTORY" =~ ".terragrunt" ]] && continue
    if [[ ! ${DIRECTORIES[@]} =~ $DIRECTORY ]]; then
        DIRECTORIES+=($DIRECTORY)

        echo "Formatting $DIRECTORY"
        (cd $DIRECTORY && terragrunt hclfmt)
    fi
done