#!/bin/bash

# Target and source directories
SOURCE_DIR="hc_life/[dev]"
TARGET_DIR="dev"

# Ensure the source directory exists to avoid errors
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Create the target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

# Empty the target directory
rm -rf "$TARGET_DIR"/*

# Copy all files and folders recursively from source to target
cp -R "$SOURCE_DIR"/. "$TARGET_DIR"

# Confirmation message
echo "Files have been copied from $SOURCE_DIR to $TARGET_DIR"