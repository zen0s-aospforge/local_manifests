#!/bin/bash

# Script to apply Binder threadpool patch
# This script should be run from the root of your Android source tree

set -e

echo "Applying Binder threadpool patch..."

# Check if we're in the right directory (should have .repo folder)
if [ ! -d ".repo" ]; then
    echo "Error: .repo directory not found!"
    echo "Please run this script from the root of your Android source tree."
    exit 1
fi

if [ ! -d "system/libhwbinder" ]; then
    echo "Warning: system/libhwbinder directory not found."
    echo "Please run 'repo sync' first to fetch the source code."
    exit 1
fi

cd system/libhwbinder
echo "Fetching commit from custom-crdroid repository..."
if git fetch https://github.com/custom-crdroid/system_libhwbinder.git d9d46e78cec0d09498fd5890eed9f7195baed0fd 2>/dev/null; then
    echo "Applying commit d9d46e78cec0d09498fd5890eed9f7195baed0fd..."
    if git cherry-pick d9d46e78cec0d09498fd5890eed9f7195baed0fd 2>/dev/null; then
        echo "Successfully applied Binder threadpool patch!"
    else
        echo "Warning: Failed to cherry-pick commit. It may already be applied or conflict with existing changes."
        git cherry-pick --abort 2>/dev/null
        exit 1
    fi
else
    echo "Warning: Failed to fetch commit from repository."
    exit 1
fi

cd - > /dev/null

cd bionic
echo "Fetching commit from yaap/bionic repository..."
if git fetch https://github.com/yaap/bionic.git 2c0a9fb575df103aef7cb257ff6f2699898a3f9c 2>/dev/null; then
    echo "Applying commit 2c0a9fb575df103aef7cb257ff6f2699898a3f9c..."
    if git cherry-pick 2c0a9fb575df103aef7cb257ff6f2699898a3f9c 2>/dev/null; then
        echo "Successfully applied bionic patch!"
    else
        echo "Warning: Failed to cherry-pick commit. It may already be applied or conflict with existing changes."
        git cherry-pick --abort 2>/dev/null
        exit 1
    fi
else
    echo "Warning: Failed to fetch commit from repository."
    exit 1
fi

cd - > /dev/null
echo "Binder patch application complete!"