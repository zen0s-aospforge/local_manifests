#!/bin/bash

# Script to download and setup local_manifests in .repo directory
# This script should be run from the root of your Android source tree

set -e

echo "Setting up local_manifests..."

# Check if we're in the right directory (should have .repo folder)
if [ ! -d ".repo" ]; then
    echo "Error: .repo directory not found!"
    echo "Please run this script from the root of your Android source tree."
    exit 1
fi

# GitHub repository details
REPO_URL="https://github.com/zen0s-aospforge/local_manifests"
BRANCH="main"

# Remove existing local_manifests if it exists
if [ -d ".repo/local_manifests" ]; then
    echo "Removing existing .repo/local_manifests..."
    rm -rf ".repo/local_manifests"
fi

# Create temporary directory for cloning
TEMP_DIR=$(mktemp -d)
echo "Downloading local_manifests from GitHub..."

# Clone the repository
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null

# Copy local_manifests to .repo directory
if [ -d "$TEMP_DIR/local_manifests" ]; then
    echo "Copying local_manifests to .repo directory..."
    cp -r "$TEMP_DIR/local_manifests" ".repo/"
    
    # Set proper permissions
    chmod -R 644 ".repo/local_manifests"/*.xml 2>/dev/null || true
    
    echo "Successfully set up local_manifests in .repo directory!"
    echo "You can now run 'repo sync' to fetch the additional repositories."
else
    echo "Error: local_manifests directory not found in the downloaded repository!"
    exit 1
fi

# Clean up temporary directory
rm -rf "$TEMP_DIR"
