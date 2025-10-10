#!/bin/bash

#Script to Cleanup Jenkin Workspace

#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Define directories to process
directories=("DEV" "QAT" "PRD")

# Base workspace path
workspace="/home/abc_user/workspace/App-1"

echo "Starting Jenkins Workspace Cleanup..."
echo "Base Path: $workspace"
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "--------------------------------------------"

# Change to workspace directory safely
cd "$workspace" || { echo "Failed to cd into $workspace"; exit 1; }

# Loop through each directory
for dir in "${directories[@]}"; do
    if [[ -d "$dir" ]]; then
        echo "Processing directory: $dir"

        # Find immediate subdirectories (depth 1)
        mapfile -t subdirs < <(find "$dir" -mindepth 1 -maxdepth 1 -type d)

        if [[ ${#subdirs[@]} -eq 0 ]]; then
            echo "No subdirectories found under $dir"
            continue
        fi

        # Loop through subdirectories and clean them
        for subdir in "${subdirs[@]}"; do
            echo "Cleaning contents of: $subdir"
            
            # Double-check to avoid nuking wrong paths
            if [[ -d "$subdir" && "$subdir" == "$workspace/"* ]]; then
                rm -rf "${subdir:?}/"*
            else
                echo "Skipping suspicious path: $subdir"
            fi
        done
    else
        echo "Directory does not exist: $dir"
    fi
    echo "--------------------------------------------"
done

echo "Jenkins Workspace Cleaning Completed Successfully!"


#--------------------------------------------

#Explanation -
# set -euo pipefail

# -e: Exit immediately if any command exits with a non-zero status.
# -u: Treat unset variables as an error and exit immediately.
# -o pipefail: The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if all commands succeed.

# IFS=$'\n\t'
# Sets the Internal Field Separator (IFS) to newline and tab only.
# This ensures that word splitting in loops and variable expansions only happens on newlines and tabs, not spaces, making the script safer when handling filenames with spaces. 

# "${subdir:?}/"*:
# "${subdir:?}" expands to the value of the subdir variable.
# The :? part is a safety feature: if subdir is unset or null, the script will exit with an error instead of running rm -rf /* (which would be catastrophic).
# The /* means "all files and folders inside this subdirectory".
