#!/bin/bash

# automated git commit and push
# adds all changes, commits with timestamp, and pushes to remote

# check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "error: not a git repository"
    exit 1
fi

# check for changes
if git diff-index --quiet HEAD --; then
    echo "status: no changes to commit"
    exit 0
fi

# add all changes
git add .

# generate commit message with timestamp
COMMIT_MSG="auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"

# commit changes
git commit -m "$COMMIT_MSG"

# push to remote (if configured)
if git remote | grep -q origin; then
    BRANCH=$(git branch --show-current)
    git push origin "$BRANCH"
    echo "status: committed and pushed to origin/$BRANCH"
else
    echo "status: committed locally (no remote configured)"
fi