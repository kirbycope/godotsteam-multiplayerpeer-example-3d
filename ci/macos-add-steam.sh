#!/bin/bash

APP_PATH="export/godotsteam-multiplayerpeer-example-3d.app"
DYLIB_PATH="export/libsteam_api.dylib"
#FRAMEWORK="export/libgodotsteam.macos.template_debug.framework"
FRAMEWORK="export/libgodotsteam.macos.template_release.framework"
TEXT_FILE="steam_appid.txt"

# Create the MacOS directory if it doesn't exist
mkdir -p "${APP_PATH}/Contents/MacOS"

# Copy the dylib
cp "${DYLIB_PATH}" "${APP_PATH}/Contents/MacOS/libsteam_api.dylib"

# Copy the framework
cp -R "${FRAMEWORK}" "${APP_PATH}/Contents/Frameworks/libgodotsteam.framework/"

# Copy the text
cp "${TEXT_FILE}" "${APP_PATH}/Contents/MacOS/steam_appid.txt"

# Report success
echo "Steam library integration complete!"
