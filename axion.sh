#!/bin/bash

# Setup Git config
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/setup_git_config.sh)

# Setup GitHub CLI only if not already installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found, installing..."
    bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/gh.sh)
else
    echo "GitHub CLI already installed, skipping..."
fi

# Initialize repo
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.0 --git-lfs

# Initial sync
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune

# Create local manifest
mkdir -p .repo/local_manifests
cat > .repo/local_manifests/alioth.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<manifest>

  <!-- <remote name="github" fetch="https://github.com/" /> -->
  <remote name="gitlab" fetch="https://gitlab.com/" />

  <!-- Camera repos -->
  <project name="johnmart19/vendor_xiaomi_camera" path="vendor/xiaomi/camera" remote="gitlab" revision="aosp-16" clone-depth="1" />
  <project name="PocoF3Releases/device_xiaomi_camera" path="device/xiaomi/camera" remote="github" revision="aosp-16" />

  <!-- Kernel -->
  <project name="zen0s-aospforge/xiaomi_sm8250_kernel" path="kernel/xiaomi/sm8250" remote="github" revision="main" clone-depth="1" />

  <!-- Hardware -->
  <project name="zen0s-aospforge/hardware_xiaomi" path="hardware/xiaomi" remote="github" revision="16" />
  <project name="zen0s-aospforge/hardware_dolby" path="hardware/dolby" remote="github" revision="c2" />

  <!-- Alioth device and vendor -->
  <project name="zen0s-aospforge/vendor_xiaomi_alioth" path="vendor/xiaomi/alioth" remote="github" revision="16" clone-depth="1" />
  <project name="zen0s-aospforge/android_device_xiaomi_alioth" path="device/xiaomi/alioth" remote="github" revision="axion" />

  <project name="zen0s-aospforge/proprietary_vendor_xiaomi_sm8250-common" path="vendor/xiaomi/sm8250-common" remote="github" revision="16" clone-depth="1" />

  <!-- GameBar -->
  <project name="zen0s-aospforge/packages_apps_GameBar" path="packages/apps/GameBar" remote="github" revision="main" />

  <!-- revanced -->
  <project name="zen0s-aospforge/vendor_revanced" path="vendor/revanced" remote="github" revision="main" />

</manifest>
EOF

# Re-sync after adding local manifest
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune

# Apply binder patch
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/apply_binder_patch.sh)

# Setup build environment
. build/envsetup.sh

bash vendor/revanced/extract-libs.sh

# Lunch and build
axion alioth user gms

ax -b user

# Upload to Google Drive only if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful! Setting up Google Drive upload..."
    if [ ! -d "gdrive_upload" ]; then
        git clone https://github.com/zen0s-aospforge/gdrive_upload.git
    fi
    python gdrive_upload/setup.py
else
    echo "Build failed! Skipping Google Drive upload."
    exit 1
fi
