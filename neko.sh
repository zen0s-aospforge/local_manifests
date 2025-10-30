#!/bin/bash

# Step 1: Setup Git Config and answer 'y'
echo 'y' | bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/setup_git_config.sh)

# Step 2: Initialize repo
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.0 --git-lfs

# Step 3: First repo sync
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# Step 4: Setup local manifests
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/setup_local_manifests.sh)

# Step 5: Second repo sync
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# Step 6: Apply binder patch
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/apply_binder_patch.sh)

# Step 7: Source envsetup.sh
. build/envsetup.sh

# Step 8: Lunch command
axion alioth user gms pico

# Step 9: Build command
ax -b user