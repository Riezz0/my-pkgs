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

# 1. Remove any existing backup files and symlinks
echo "Cleaning up old database files..."
rm -f *.old
rm -f "$REPO_NAME.db" "$REPO_NAME.files"

# 2. Update the database 
# -n (or --new) tells repo-add to not create .old backup files
echo "Updating the repository database..."
repo-add -n "$REPO_NAME.db.tar.gz" *.pkg.tar.zst

# 3. Fix for GitHub Pages (replacing symlinks with actual files)
echo "Generating static files for GitHub Pages..."
rm my-pkgs.db 
rm my-pkgs.files
rm my-pkgs.db.tar.gz.old
rm my-pkgs.files.tar.gz.old
cp "$REPO_NAME.db.tar.gz" "$REPO_NAME.db"
cp "$REPO_NAME.files.tar.gz" "$REPO_NAME.files"

# 4. Git operations
echo "Syncing with GitHub..."
cd ..
git add .
git commit -m "Update repo and remove backups: $(date +'%Y-%m-%d %H:%M:%S')"
git push origin main

echo "Done! Your clean repo is live."
