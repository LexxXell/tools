#!/bin/bash

# Path to the configuration file
CONFIG_FILE="/home/lexx/workspace/tools/vncconnect/connection.conf"

# Variable to store the SSH process PID
SSH_PID=""

# Flag to indicate successful SSH connection
SSH_CONNECTED=0

# Function to connect to SSH
connect_ssh() {
    # Check arguments
    if [ $# -ne 2 ]; then
        echo "Usage: connect_ssh <ssh_hostname> <vnc_port>"
        exit 1
    fi

    attempts=1
    max_attempts=5
    while [ $attempts -le $max_attempts ]; do
        echo "Attempting SSH connection (Attempt $attempts)..."
        # Connect to SSH without pseudo-terminal and in the background
        ssh -T -N -L "$2:localhost:$2" "$1" &
        # Save the SSH process PID
        SSH_PID=$!
        sleep 5 # Give some time to establish the connection

        # Check if SSH connection is established
        if ps -p $SSH_PID > /dev/null; then
            echo "SSH connection established."
            SSH_CONNECTED=1
            return 0
        else
            echo "Failed to establish SSH connection. Retrying..."
            ((attempts++))
        fi
    done

    # If the connection is not established after all attempts, display an error message and exit the script
    echo "Failed to establish SSH connection after $max_attempts attempts. Exiting."
    exit 1
}

# Function to connect to VNC
connect_vnc() {
    # Check arguments
    if [ $# -ne 2 ]; then
        echo "Usage: connect_vnc <vnc_password_file> <vnc_port>"
        exit 1
    fi

    # Check if SSH connection is established
    if [ $SSH_CONNECTED -eq 0 ]; then
        echo "SSH connection not established. Exiting."
        exit 1
    fi

    # Add a small delay before starting the VNC Viewer
    sleep 5
    # Connect to VNC
    vncviewer -passwd "$1" "localhost:$2"
}

# Function to handle script termination signal
cleanup() {
    # Check if the SSH tunnel is running
    if [ -n "$SSH_PID" ]; then
        echo "Closing SSH tunnel..."
        # Terminate the SSH process
        kill "$SSH_PID"
    fi
}

# Register script termination signal handler
trap cleanup EXIT

# Function to read the configuration file
read_config() {
    # Check if the configuration file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Configuration file '$CONFIG_FILE' not found."
        exit 1
    fi

    # Read the file line by line
    while IFS= read -r line; do
        # Split the line into fields
        config_name=$(echo "$line" | cut -d ':' -f 1)
        ssh_hostname=$(echo "$line" | cut -d ':' -f 2)
        vnc_port=$(echo "$line" | cut -d ':' -f 3)
        vnc_password_file=$(echo "$line" | cut -d ':' -f 4)

        # Output data (for verification)
        echo "Config Name: $config_name"
        echo "SSH Hostname: $ssh_hostname"
        echo "VNC Port: $vnc_port"
        echo "VNC Password File: $vnc_password_file"
        echo "--------------------------------------"

        # Connect to SSH
        connect_ssh "$ssh_hostname" "$vnc_port"

        # Connect to VNC only if SSH connection is established
        connect_vnc "$vnc_password_file" "$vnc_port"
    done <"$CONFIG_FILE"
}

# Call the function to read the configuration file
read_config
