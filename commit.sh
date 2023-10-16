#!/bin/sh

# Check if there are changes to git
if [ -n "$(git status -s)" ]; then

  # Add changes to git
  git add .

  # Commit changes
  git commit -m "$(date)"

  # Push changes
  git push origin master

fi
