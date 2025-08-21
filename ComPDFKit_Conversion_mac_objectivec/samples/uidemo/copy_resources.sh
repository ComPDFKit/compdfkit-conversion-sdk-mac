#!/usr/bin/env bash
set -euo pipefail


SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR=${1:-"$SCRIPT_DIR/build"}
ARCH=${2:-$(uname -m)}

if [ "$ARCH" = "arm" ] || [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
fi

if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "arm64" ]; then
  echo "Unsupported arch: $ARCH"
  exit 2
fi

if [ "$ARCH" = "x86_64" ]; then
  APP_NAME="uidemo_x64"
else
  APP_NAME="uidemo_arm64"
fi

# Determine app executable and its architecture to select correct libs
APP_EXE_DIR="$BUILD_DIR/${APP_NAME}.app/Contents/MacOS"
APP_EXE=""
if [ -d "$APP_EXE_DIR" ]; then
  # assume single executable inside MacOS
  APP_EXE=$(ls "$APP_EXE_DIR" | head -n1)
  APP_EXE_PATH="$APP_EXE_DIR/$APP_EXE"
else
  APP_EXE_PATH=""
fi

BIN_ARCH=""
if [ -n "$APP_EXE_PATH" ] && [ -f "$APP_EXE_PATH" ]; then
  if command -v lipo >/dev/null 2>&1; then
    archs=$(lipo -info "$APP_EXE_PATH" 2>/dev/null || true)
    if echo "$archs" | grep -q "arm64"; then
      BIN_ARCH="arm64"
    elif echo "$archs" | grep -q "x86_64"; then
      BIN_ARCH="x86_64"
    fi
  fi
  if [ -z "$BIN_ARCH" ]; then
    # fallback to file
    fileout=$(file "$APP_EXE_PATH" 2>/dev/null || true)
    if echo "$fileout" | grep -q "arm64"; then
      BIN_ARCH="arm64"
    elif echo "$fileout" | grep -q "x86_64"; then
      BIN_ARCH="x86_64"
    fi
  fi
fi

if [ "$BIN_ARCH" = "x86_64" ]; then
  LIB_SRC="$SCRIPT_DIR/../../lib"
elif [ "$BIN_ARCH" = "arm64" ]; then
  LIB_SRC="$SCRIPT_DIR/../../lib"
else
  # fallback to host-detected arch
  if [ "$ARCH" = "x86_64" ]; then
    LIB_SRC="$SCRIPT_DIR/../../lib"
  else
    LIB_SRC="$SCRIPT_DIR/../../lib"
  fi
fi

APP_BUNDLE="$BUILD_DIR/${APP_NAME}.app"
RES_SRC="$SCRIPT_DIR/../../resource"
MODELS_SRC="$RES_SRC/models"
FONTS_SRC="$RES_SRC/fonts"
LICENSE_SRC="$RES_SRC/license"

echo "Script dir: $SCRIPT_DIR"
echo "Build dir: $BUILD_DIR"
echo "Arch: $ARCH"
echo "App bundle: $APP_BUNDLE"

if [ ! -d "$APP_BUNDLE" ]; then
  echo "Error: app bundle not found: $APP_BUNDLE" >&2
  exit 3
fi

RESOURCE_DEST="$BUILD_DIR/resource"
mkdir -p "$RESOURCE_DEST"
if command -v rsync >/dev/null 2>&1; then
  echo "Copying resource -> $RESOURCE_DEST (rsync)"
  rsync -a --delete "$RES_SRC/" "$RESOURCE_DEST/"
else
  echo "Copying resource -> $RESOURCE_DEST (cp)"
  rm -rf "$RESOURCE_DEST"
  mkdir -p "$RESOURCE_DEST"
  cp -a "$RES_SRC/" "$RESOURCE_DEST/"
fi

APP_RESOURCES_DIR="$APP_BUNDLE/Contents/Resources"
mkdir -p "$APP_RESOURCES_DIR/models" "$APP_RESOURCES_DIR/fonts"

if [ -d "$MODELS_SRC" ]; then
  echo "Copying models -> $APP_RESOURCES_DIR/models"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$MODELS_SRC/" "$APP_RESOURCES_DIR/models/"
  else
    rm -rf "$APP_RESOURCES_DIR/models"
    cp -a "$MODELS_SRC" "$APP_RESOURCES_DIR/models"
  fi
else
  echo "Warning: models dir not found: $MODELS_SRC"
fi

if [ -d "$FONTS_SRC" ]; then
  echo "Copying fonts -> $APP_RESOURCES_DIR/fonts"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$FONTS_SRC/" "$APP_RESOURCES_DIR/fonts/"
  else
    rm -rf "$APP_RESOURCES_DIR/fonts"
    cp -a "$FONTS_SRC" "$APP_RESOURCES_DIR/fonts"
  fi
else
  echo "Warning: fonts dir not found: $FONTS_SRC"
fi

if [ -d "$LICENSE_SRC" ]; then
  echo "Copying license -> $APP_RESOURCES_DIR/license"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$LICENSE_SRC/" "$APP_RESOURCES_DIR/license/"
  else
    rm -rf "$APP_RESOURCES_DIR/license"
    cp -a "$LICENSE_SRC" "$APP_RESOURCES_DIR/license"
  fi
else
  echo "Warning: license dir not found: $LICENSE_SRC"
fi

APP_FRAMEWORKS_DIR="$APP_BUNDLE/Contents/Frameworks"
mkdir -p "$APP_FRAMEWORKS_DIR"

if [ -d "$LIB_SRC" ]; then
  echo "Copying libs ($LIB_SRC) -> $APP_FRAMEWORKS_DIR"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$LIB_SRC/" "$APP_FRAMEWORKS_DIR/"
  else
    cp -a "$LIB_SRC/" "$APP_FRAMEWORKS_DIR/"
  fi
else
  echo "Warning: lib dir not found: $LIB_SRC"
fi

if command -v xattr >/dev/null 2>&1; then
  echo "Removing com.apple.quarantine from $APP_BUNDLE"
  xattr -d com.apple.quarantine "$APP_BUNDLE" 2>/dev/null || true
fi

echo "Done."
exit 0
