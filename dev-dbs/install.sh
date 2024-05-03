#!/bin/bash

# Path to the DevDBs run.sh and autocomplete.sh scripts
DEVDBS_DIR=$(realpath "$(dirname "$0")")

# Check that files are not empty
if ! grep -q "# Initialize DevDBs" ~/.bashrc; then
    # Add lines to ~/.bashrc
    echo "" >>~/.bashrc
    echo "# Initialize DevDBs" >>~/.bashrc
    echo "export DEVDBS_DIR=$DEVDBS_DIR" >>~/.bashrc
    echo '[ -s "$DEVDBS_DIR/run.sh" ] && alias dev-dbs="$DEVDBS_DIR/run.sh"' >>~/.bashrc
    echo '[ -s "$DEVDBS_DIR/autocomplete.sh" ] && \. "$DEVDBS_DIR/autocomplete.sh"' >>~/.bashrc

    # Message for successful completion
    echo "DevDBs successfully added to ~/.bashrc"
else
    # Message for successful completion
    echo "DevDBs already added to ~/.bashrc"
fi
