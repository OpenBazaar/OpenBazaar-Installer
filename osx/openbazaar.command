#!/usr/bin/env bash

# make sure we are in the correct dir when we double-click a .command file
dir=${0%/*}
if [ -d "$dir" ]; then
  cd "$dir"
fi

# set up your app name, version number, and background image file name
APP_NAME="OpenBazaar"
VERSION="1.0.0"
DMG_BACKGROUND_IMG="Background.png"

# you should not need to change these
APP_EXE="${APP_NAME}.app/Contents/MacOS/${APP_NAME}"

VOL_NAME="${APP_NAME} ${VERSION}"   # volume name will be "OpenBazaar 1.0.0"
DMG_TMP="${VOL_NAME}-temp.dmg"
DMG_FINAL="${VOL_NAME}.dmg"         # final DMG name
STAGING_DIR="./build"             # we copy all our stuff into this dir