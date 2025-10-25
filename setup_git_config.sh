#!/bin/bash

# Script to configure Git settings and authentication cookies for Android development
# This script sets up git username/email and Android repository authentication

set -e

echo "Setting up Git configuration for Android development..."

# Configure git username and email
echo "Configuring git user settings..."
git config --global user.name "zenzer0s"
git config --global user.email "praveenzalaki200@gmail.com"

echo "Git user configured: zenzer0s <praveenzalaki200@gmail.com>"

# Setup git cookies for Android repositories
echo "Setting up Android repository authentication cookies..."

# Disable history temporarily to avoid storing sensitive cookie data
eval 'set +o history' 2>/dev/null || setopt HIST_IGNORE_SPACE 2>/dev/null

# Create gitcookies file if it doesn't exist
touch ~/.gitcookies
chmod 0600 ~/.gitcookies

# Configure git to use the cookie file
git config --global http.cookiefile ~/.gitcookies

# Add Android authentication cookies
tr , \\t <<\__END__ >>~/.gitcookies
android.googlesource.com,FALSE,/,TRUE,2147483647,o,git-praveenzalaki200.gmail.com=1//0gXrHudycYLY2CgYIARAAGBASNgF-L9IrUK48ubH4LnrahEp4a9F4__FaLr5VjZtxTSMigSr5EeMnbFCmuLWpZGRfCitfFLDSKQ
android-review.googlesource.com,FALSE,/,TRUE,2147483647,o,git-praveenzalaki200.gmail.com=1//0gXrHudycYLY2CgYIARAAGBASNgF-L9IrUK48ubH4LnrahEp4a9F4__FaLr5VjZtxTSMigSr5EeMnbFCmuLWpZGRfCitfFLDSKQ
__END__

# Re-enable history
eval 'set -o history' 2>/dev/null || unsetopt HIST_IGNORE_SPACE 2>/dev/null

echo "Android repository authentication cookies configured."
echo "Git setup complete!"
echo ""
echo "You can now clone and work with Android repositories."