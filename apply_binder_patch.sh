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

# Patch 1: system/libhwbinder
cd system/libhwbinder
echo "Fetching commit from custom-crdroid repository..."
if git fetch https://github.com/custom-crdroid/system_libhwbinder.git d9d46e78cec0d09498fd5890eed9f7195baed0fd 2>/dev/null; then
    echo "Applying commit d9d46e78cec0d09498fd5890eed9f7195baed0fd..."
    if git cherry-pick d9d46e78cec0d09498fd5890eed9f7195baed0fd 2>/dev/null; then
        echo "✅ Successfully applied Binder threadpool patch!"
    else
        echo "⚠️ Warning: Failed to cherry-pick libhwbinder commit. It may already be applied or have conflicts."
        echo "   Aborting this patch and continuing..."
        git cherry-pick --abort 2>/dev/null || true
    fi
else
    echo "⚠️ Warning: Failed to fetch libhwbinder commit from repository. Skipping this patch."
fi
cd - > /dev/null

# Patch 2: bionic
if [ -d "bionic" ]; then
    cd bionic
    echo "Fetching commit from yaap/bionic repository..."
    if git fetch https://github.com/yaap/bionic.git 2c0a9fb575df103aef7cb257ff6f2699898a3f9c 2>/dev/null; then
        echo "Applying commit 2c0a9fb575df103aef7cb257ff6f2699898a3f9c..."
        if git cherry-pick 2c0a9fb575df103aef7cb257ff6f2699898a3f9c 2>/dev/null; then
            echo "✅ Successfully applied bionic patch!"
        else
            echo "⚠️ Warning: Failed to cherry-pick bionic commit. It may already be applied or have conflicts."
            echo "   Aborting this patch and continuing..."
            git cherry-pick --abort 2>/dev/null || true
        fi
    else
        echo "⚠️ Warning: Failed to fetch bionic commit from repository. Skipping this patch."
    fi
    cd - > /dev/null
else
    echo "⚠️ Warning: bionic directory not found. Skipping bionic patch."
fi

# Patch 3: frameworks/base
if [ -d "frameworks/base" ]; then
    cd frameworks/base
    echo "Fetching commit from PixelLineage/frameworks_base repository..."
    if git fetch https://github.com/PixelLineage/frameworks_base.git bc71449a25b6b0d16d2b4e611cdc9939bd89bb54 2>/dev/null; then
        echo "Applying commit bc71449a25b6b0d16d2b4e611cdc9939bd89bb54..."
        if git cherry-pick bc71449a25b6b0d16d2b4e611cdc9939bd89bb54 2>/dev/null; then
            echo "✅ Successfully applied frameworks/base patch!"
        else
            echo "⚠️ Warning: Failed to cherry-pick frameworks/base commit. It may already be applied or have conflicts."
            echo "   Aborting this patch and continuing..."
            git cherry-pick --abort 2>/dev/null || true
        fi
    else
        echo "⚠️ Warning: Failed to fetch frameworks/base commit from repository. Skipping this patch."
    fi
    cd - > /dev/null
else
    echo "⚠️ Warning: frameworks/base directory not found. Skipping frameworks/base patch."
fi

echo "Binder patch application complete!"