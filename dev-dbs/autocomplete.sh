#!/bin/bash

# Path to the directory containing docker-compose files
COMPOSE_DIR="/home/lexx/workspace/tools/dev-dbs/"

# Function for autocompleting words based on entered text
_complete_dev_dbs_projects() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD - 1]}"

    # If the previous word is 'dev-dbs', autocomplete based on the docker-compose project names
    if [[ "$prev" == "dev-dbs" ]]; then
        local options=$(find "$COMPOSE_DIR" -type f -name 'docker-compose.*.yml' | sed -n 's|.*/docker-compose.\(.*\).yml|\1|p')
        COMPREPLY=($(compgen -W "$options" -- "$cur"))
    else
        local options="up down"
        COMPREPLY=($(compgen -W "$options" -- "$cur"))
    fi
}

# Register autocompletion function for the 'dev-dbs' command
complete -F _complete_dev_dbs_projects dev-dbs
