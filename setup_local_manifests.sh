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

# GitHub raw file URL
RAW_URL="https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/local_manifests/alioth.xml"

# Remove existing local_manifests if it exists
if [ -d ".repo/local_manifests" ]; then
    echo "Removing existing .repo/local_manifests..."
    rm -rf ".repo/local_manifests"
fi

# Create local_manifests directory
echo "Creating .repo/local_manifests directory..."
mkdir -p ".repo/local_manifests"

# Download the manifest file
echo "Downloading alioth.xml..."
if command -v curl >/dev/null 2>&1; then
    curl -s "$RAW_URL" -o ".repo/local_manifests/alioth.xml"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$RAW_URL" -O ".repo/local_manifests/alioth.xml"
else
    echo "Error: Neither curl nor wget is available!"
    exit 1
fi

# Check if download was successful
if [ ! -f ".repo/local_manifests/alioth.xml" ] || [ ! -s ".repo/local_manifests/alioth.xml" ]; then
    echo "Error: Failed to download the manifest file!"
    exit 1
fi

# Set proper permissions
chmod 644 ".repo/local_manifests/alioth.xml"

echo "Successfully set up local_manifests in .repo directory!"
echo "Downloaded alioth.xml manifest file."

# Apply the Binder patch
echo "Applying Binder threadpool patch..."

if [ ! -d "system/libhwbinder" ]; then
    echo "Warning: system/libhwbinder directory not found."
    echo "The patch will need to be applied manually after syncing the source."
else
    cd system/libhwbinder
    echo "Fetching commit from custom-crdroid repository..."
    if git fetch https://github.com/custom-crdroid/system_libhwbinder.git d9d46e78cec0d09498fd5890eed9f7195baed0fd 2>/dev/null; then
        echo "Applying commit d9d46e78cec0d09498fd5890eed9f7195baed0fd..."
        if git cherry-pick d9d46e78cec0d09498fd5890eed9f7195baed0fd 2>/dev/null; then
            echo "Successfully applied Binder threadpool patch!"
        else
            echo "Warning: Failed to cherry-pick commit. It may already be applied or conflict with existing changes."
            git cherry-pick --abort 2>/dev/null
        fi
    else
        echo "Warning: Failed to fetch commit from repository."
    fi
    cd - > /dev/null
fi

echo ""
echo "Setup complete! You can now run 'repo sync' to fetch the additional repositories."
