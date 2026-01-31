#!/bin/bash

# project boilerplate generator
# creates standard project structure with git initialization

read -p "project name: " PROJECT_NAME

if [[ -z "$PROJECT_NAME" ]]; then
    echo "error: project name required"
    exit 1
fi

# create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit 1

# create directory structure
mkdir -p src docs tests

# generate readme
cat > README.md << EOF
# $PROJECT_NAME

## description
brief description of the project.

## installation
instructions for installation.

## usage
how to use the project.

## contributing
guidelines for contributing.
EOF

# generate gitignore
cat > .gitignore << EOF
# dependencies
node_modules/
venv/
__pycache__/

# ide
.vscode/
.idea/

# os
.DS_Store
Thumbs.db

# logs
*.log
EOF

# initialize git
git init
git add .
git commit -m "initial commit"

echo "path: $(pwd)"
echo "status: project '$PROJECT_NAME' created"