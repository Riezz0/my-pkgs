#!/bin/bash

# - Change Directory
cd /home/$USER/git/my-pkgs/x86_64

# - Remove Existing Database
#
rm my-pkgs.db
rm my-pkgs.files

# - Build The Repo Packages
#
repo-add my-pkgs.db.tar.zst *.pkg.tar.zst

# - Remove Symlinks 
#
rm my-pkgs.db 
rm my-pkgs.files

# - Rename Database files
#
mv my-pkgs.db.tar.zst my-pkgs.db 
mv my-pkgs.files.tar.zst my-pkgs.files

# - Push The Repo To Github
#
cd /home/$USER/git/my-pkgs/
git add .
sleep 3
git commit --allow-empty-message -m ''
sleep 3
git push

