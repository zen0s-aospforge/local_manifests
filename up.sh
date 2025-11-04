#!/bin/bash

# === CONFIGURATION ===
DEVICE="alioth"
SF_USER="zenzer0s"
SF_PATH="/home/frs/p/infinity-x"
BUILD_PATH="out/target/product/${DEVICE}"

# === FIND ALL MATCHING ZIPS ===
ZIP_FILES=$(find "${BUILD_PATH}" -type f -name "*${DEVICE}*zip" | grep -E "GAPPS|VANILLA")

if [ -z "$ZIP_FILES" ]; then
    echo "❌ No Infinity-X zips found in ${BUILD_PATH}"
    exit 1
fi

echo "📦 Found the following builds:"
echo "$ZIP_FILES"
echo

# === LOOP THROUGH EACH ZIP ===
for ZIP_FILE in $ZIP_FILES; do
    if [[ "$ZIP_FILE" == *"GAPPS"* ]]; then
        VARIANT="gapps"
    elif [[ "$ZIP_FILE" == *"VANILLA"* ]]; then
        VARIANT="vanilla"
    else
        echo "⚠️ Skipping unknown variant: $ZIP_FILE"
        continue
    fi

    DEST="${SF_USER}@frs.sourceforge.net:${SF_PATH}/${DEVICE}/16/${VARIANT}"
    echo "📤 Uploading $ZIP_FILE → ${DEST}"

    scp "$ZIP_FILE" "$DEST"
    if [ $? -eq 0 ]; then
        echo "✅ Successfully uploaded $VARIANT build"
    else
        echo "❌ Failed to upload $VARIANT build"
    fi

    echo "------------------------------------"
done
