# Local Manifests for Xiaomi Alioth (POCO F3)

## Setup

### Step 1: Configure Git (Required)
First, configure your Git settings and Android repository authentication:

```bash
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/setup_git_config.sh)
```

### Step 2: Setup Local Manifests
Run this command in your Android source root directory to download and setup the local manifests:

```bash
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/setup_local_manifests.sh)
```

### Step 3: Sync Repositories
Then run `repo sync` to fetch the additional repositories:

```bash
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
```

### Step 4: Apply Binder Patch (Optional)
After syncing, apply the Binder threadpool patch:

```bash
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/apply_binder_patch.sh)
```

### Step 5: Run Automated Setup and Build (Optional)
Alternatively, run the automated script to handle the full process:

```bash
bash <(curl -s https://raw.githubusercontent.com/zen0s-aospforge/local_manifests/main/neko.sh)
```

## Scripts

- `setup_git_config.sh`: Configures Git username/email and Android repository authentication cookies
- `setup_local_manifests.sh`: Downloads and sets up the local manifests XML file
- `apply_binder_patch.sh`: Applies the Binder threadpool patch via git cherry-pick
- `neko.sh`: Automates the full setup and build process for AxionAOSP
