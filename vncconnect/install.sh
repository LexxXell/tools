#!/bin/bash

# Path to the vncconnect.sh and autocomplete.sh scripts
VNCCONNECT_DIR=$(realpath "$(dirname "$0")")

# Check that files are not empty
if ! grep -q "# Initialize VNCConnect" ~/.bashrc; then
    # Add lines to ~/.bashrc
    echo "" >>~/.bashrc
    echo "# Initialize VNCConnect" >>~/.bashrc
    echo "export VNCCONNECT_DIR=$VNCCONNECT_DIR" >>~/.bashrc
    echo '[ -s "$VNCCONNECT_DIR/connect.sh" ] && alias vncconnect="$VNCCONNECT_DIR/connect.sh"' >>~/.bashrc
    echo '[ -s "$VNCCONNECT_DIR/autocomplete.sh" ] && \. "$VNCCONNECT_DIR/autocomplete.sh"' >>~/.bashrc

    # Message for successful completion
    echo "VNCConnect successfully added to ~/.bashrc"
else
    # Message for successful completion
    echo "VNCConnect already added to ~/.bashrc"
fi
