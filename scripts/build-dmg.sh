#!/bin/zsh

set -e

if [ -z "$APP_NAME" ]; then
  echo "APP_NAME env is required." >&2
  exit 1
fi

if ! command -v create-dmg >/dev/null 2>&1; then
   echo "Installing create-dmg"
   HOMEBREW_NO_AUTO_UPDATE=1 brew install create-dmg
fi

create-dmg --version

APP_FILE_NAME="pay_id"

BASE_APP_DIR="$APP_FILE_NAME.app"
DMG_FILE_NAME="$APP_PREFIX-macos-universal.dmg"
PACK_DIR="macos/packaging"
TARGET_DIR="build/macos/Build/Products/Release"

test -f "$DMG_FILE_NAME" && rm -f "$DMG_FILE_NAME"

create-dmg \
  --volname "$APP_NAME" \
  --volicon "$PACK_DIR/dmg/app_icon.icns" \
  --background "$PACK_DIR/dmg/background.png" \
  --window-pos 200 180 \
  --window-size 660 500 \
  --icon-size 100 \
  --icon "$BASE_APP_DIR" 180 170 \
  --hide-extension "$BASE_APP_DIR" \
  --app-drop-link 480 170 \
  "$DMG_FILE_NAME" \
  "$TARGET_DIR/$BASE_APP_DIR"

exit 0