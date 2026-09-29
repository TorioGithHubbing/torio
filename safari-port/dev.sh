#!/bin/sh
# One-step update for the Safari port: pull, build, rebuild the Xcode app, launch it.
# Run from anywhere: sh ~/torio/safari-port/dev.sh
set -e
cd "$(dirname "$0")"

git pull --ff-only
npm install --no-audit --no-fund
npm run build:safari

xcodebuild \
  -project "Ambient Light/Ambient Light.xcodeproj" \
  -scheme "Ambient Light (macOS)" \
  -destination 'platform=macOS' \
  build

APP=$(find ~/Library/Developer/Xcode/DerivedData/Ambient_Light-*/Build/Products/Debug \
  -maxdepth 1 -name "Ambient Light.app" | head -1)
open "$APP"

echo
echo "Done. Now: quit Safari (Cmd+Q), reopen it, Develop > Allow Unsigned Extensions,"
echo "then reload the YouTube tab."
