#!/bin/bash

# Configuration
REPO_NAME="my-pkgs"
ARCH="x86_64"

# Ensure we are in the architecture directory
if [ -d "$ARCH" ]; then
    cd "$ARCH" || exit
else
    echo "Directory $ARCH not found. Are you in the repo root?"
    exit 1
fi

# 1. Remove any existing database files, symlinks, and ALL variations of .old files
echo "Cleaning up old database files and backups..."
# This removes the symlinks and any file ending in .old or .old.gz
rm -f "$REPO_NAME.db" "$REPO_NAME.files"
rm -f *.old *.old.gz *.old.tar.gz

# 2. Update the database 
# The -n flag prevents repo-add from creating NEW .old files during this run
echo "Updating the repository database..."
repo-add -n "$REPO_NAME.db.tar.gz" *.pkg.tar.zst

# 3. Fix for GitHub Pages (replacing symlinks with actual files)
# We remove the symlink names first to ensure 'cp' creates a fresh file
echo "Generating static files for GitHub Pages..."
rm -f "$REPO_NAME.db" "$REPO_NAME.files"
cp "$REPO_NAME.db.tar.gz" "$REPO_NAME.db"
cp "$REPO_NAME.files.tar.gz" "$REPO_NAME.files"

# 4. Final Cleanup (Safety pass to catch anything repo-add might have dropped)
rm -f *.old *.old.gz

# 5. Git operations
echo "Syncing with GitHub..."
cd ..
git add .
git commit -m "Update repo and remove backups: $(date +'%Y-%m-%d %H:%M:%S')"
git push origin main

echo "Done! Your clean repo is live."
