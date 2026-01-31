#!/bin/bash

# automatic file organizer for downloads
# sorts files by type into subdirectories

DOWNLOADS_DIR="$HOME/Downloads"
cd "$DOWNLOADS_DIR" || exit 1

echo "path: $DOWNLOADS_DIR"
echo "status: organizing files"

# create directories
mkdir -p PDFs Images Videos Music Archives Others

# move files by extension
for file in *; do
    # skip directories and hidden files
    [[ -d "$file" || "$file" == .* ]] && continue
    
    case "${file,,}" in
        *.pdf) mv "$file" PDFs/ ;;
        *.jpg|*.jpeg|*.png|*.gif|*.bmp|*.svg) mv "$file" Images/ ;;
        *.mp4|*.avi|*.mkv|*.mov|*.wmv) mv "$file" Videos/ ;;
        *.mp3|*.wav|*.flac|*.aac) mv "$file" Music/ ;;
        *.zip|*.tar|*.gz|*.rar|*.7z) mv "$file" Archives/ ;;
        *) mv "$file" Others/ ;;
    esac
done

echo "status: organization complete"