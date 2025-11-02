#!/bin/bash

# Step 1: Setup Git Config and answer 'y'
echo 'y' | bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/setup_git_config.sh)

# Step 2: Initialize repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault

# Step 3: First repo sync
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# Step 4: Setup local manifests
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/rom.sh)

# Step 5: Second repo sync
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# Step 6: Apply binder patch
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/apply_binder_patch.sh)

# Step 7: Clone infinity priv keys
git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys vendor/infinity-priv/keys

# Step 8: Source envsetup.sh
. build/envsetup.sh

# Step 9: Lunch command
lunch infinity_alioth-user

# Step 10: Build command
m bacon