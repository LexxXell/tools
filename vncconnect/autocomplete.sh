#!/bin/bash

# Path to the configuration file
CONFIG_FILE="/home/lexx/workspace/tools/vncconnect/connection.conf"

# Function for autocompleting words based on entered text
_complete_vncconnect_config_name() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    # If the previous word is 'vncconnect', autocomplete based on the content of the configuration file
    if [[ "$prev" == "vncconnect" ]]; then
        local options=$(cut -d ':' -f 1 "$CONFIG_FILE")
        COMPREPLY=($(compgen -W "$options" -- "$cur"))
    fi
}

# Register autocompletion function for the 'vncconnect' command
complete -F _complete_vncconnect_config_name vncconnect
