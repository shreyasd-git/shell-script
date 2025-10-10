#backup files older than 30 days to s3

#!/bin/bash

# ===== Vars =====
SOURCE_DIR="/path/to/your/folder"         # Local folder to back up
S3_BUCKET="s3://your-bucket-name/backups" # S3 target path
DAYS_OLD=90                               # Age threshold
DELETE_AFTER_UPLOAD=false                 # Set to true if you wanna delete after upload

# Requirements functions
check_requirements() {
  if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
  fi

  if ! command -v aws &> /dev/null; then
    echo "AWS CLI not installed. Run: pip install awscli or brew install awscli"
    exit 1
  fi
}

# function to find old files
find_old_files() {
  echo "Scanning for files older than $DAYS_OLD days..."
  find "$SOURCE_DIR" -type f -mtime +$DAYS_OLD
}

# function to upload files to s3
# "${file#$SOURCE_DIR/}": Uses Bash parameter expansion to remove the $SOURCE_DIR/ prefix from the $file path. This gives the relative path of the file within the source directory. so when uploading to S3, the folder structure is preserved under the S3 bucket.
upload_to_s3() {
  local file="$1"
  local rel_path="${file#$SOURCE_DIR/}"
  aws s3 cp "$file" "$S3_BUCKET/$rel_path" --storage-class STANDARD_IA
}

# function to delete local file
delete_local_file() {
  local file="$1"
  rm -f "$file"
  echo "Deleted local file: $file"
}

# Main backup function
#IFS=: Sets the Internal Field Separator to nothing, so leading/trailing whitespace is preserved.
#read -r file: Reads a line from input into the variable file. The -r option prevents backslash escapes from being interpreted.
backup_files() {
  local files
  files=$(find_old_files)

  if [ -z "$files" ]; then
    echo "No files older than $DAYS_OLD days found. Nothing to back up."
    return
  fi

  echo "Uploading files to $S3_BUCKET..."
  while IFS= read -r file; do
    upload_to_s3 "$file" && echo "Backed up: $file"
    if [ "$DELETE_AFTER_UPLOAD" = true ]; then
      delete_local_file "$file"
    fi
  done <<< "$files"

  echo "Backup completed successfully!"
}

main() {
  check_requirements
  backup_files
}

# ===== RUN IT =====
main