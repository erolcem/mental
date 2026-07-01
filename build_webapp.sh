#!/bin/bash
# build_webapp.sh — Rebuild the Wisdom web app and sync it into the iOS bundle
# Run this from the project root (/home/erolc/Projects/mental/) whenever you change the React code

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WISDOM_DIR="$SCRIPT_DIR/Wisdom"
IOS_WEBAPP_DIR="$SCRIPT_DIR/ios/Mental/webapp"

echo "🔨 Building Wisdom web app..."
cd "$WISDOM_DIR"
npm run build

echo "📦 Syncing to iOS bundle..."
rm -rf "$IOS_WEBAPP_DIR"
cp -r "$WISDOM_DIR/dist" "$IOS_WEBAPP_DIR"

echo "✅ Done! webapp folder updated at: $IOS_WEBAPP_DIR"
echo "   Open ios/Mental.xcodeproj in Xcode and build."
