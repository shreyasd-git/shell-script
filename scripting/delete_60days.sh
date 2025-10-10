#!/bin/bash

# Target directory (change this to your folder)
TARGET_DIR="/path/to/your/folder"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist."
  exit 1
fi

# Delete files and folders older than 60 days
find "$TARGET_DIR" -mindepth 1 -mtime +60 -exec rm -rf {} +

echo "✅ All files and folders older than 60 days in '$TARGET_DIR' have been deleted."

#--------------------------------------------#
#DRY RUN
#find "$TARGET_DIR" -mindepth 1 -mtime +60 -print


#Explanation:

# find "$TARGET_DIR": Searches for files and directories inside the specified target directory.
# -mindepth 1: Excludes the top-level directory itself from the results (so it doesn't try to delete the root of your target).
# -mtime +60: Matches files and directories last modified more than 60 days ago.
# -exec rm -rf {} +: For each found item, runs rm -rf to forcefully and recursively delete it. The {} is replaced by the found file/directory names, and + means as many as possible are passed to each rm command for efficiency.