#!/bin/bash

# Script to copy local_manifests to .repo directory
# This script should be run from the root of your Android source tree

set -e

echo "Setting up local_manifests..."

# Check if we're in the right directory (should have .repo folder)
if [ ! -d ".repo" ]; then
    echo "Error: .repo directory not found!"
    echo "Please run this script from the root of your Android source tree."
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if local_manifests exists in the same directory as this script
if [ ! -d "$SCRIPT_DIR/local_manifests" ]; then
    echo "Error: local_manifests directory not found in script directory!"
    echo "Expected: $SCRIPT_DIR/local_manifests"
    exit 1
fi

# Remove existing local_manifests if it exists
if [ -d ".repo/local_manifests" ]; then
    echo "Removing existing .repo/local_manifests..."
    rm -rf ".repo/local_manifests"
fi

# Copy local_manifests to .repo directory
echo "Copying local_manifests to .repo directory..."
cp -r "$SCRIPT_DIR/local_manifests" ".repo/"

# Set proper permissions
chmod -R 644 ".repo/local_manifests"/*.xml

echo "Successfully set up local_manifests in .repo directory!"
echo "You can now run 'repo sync' to fetch the additional repositories."
