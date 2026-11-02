#!/bin/bash
set -euo pipefail
version="${1:?usage: build-app.sh <version>}"
src="$(cd "$(dirname "$0")" && pwd)"
out="$src/dist"
app="$out/VoxLock Mic.app"
rm -rf "$out"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
sed "s/@VERSION@/$version/g" "$src/app/Info.plist" > "$app/Contents/Info.plist"
clang -O2 -arch arm64 -arch x86_64 -mmacosx-version-min=14.0 -framework CoreAudio -framework CoreFoundation -o "$app/Contents/MacOS/launcher" "$src/app/launcher.c"
install -m 755 "$src/app/run.sh" "$app/Contents/Resources/run.sh"
install -m 755 "$src/voxlock-mic" "$app/Contents/Resources/voxlock-mic"
codesign --force --deep --sign - "$app"
codesign --verify --deep --strict "$app"
(cd "$out" && ditto -c -k --keepParent "VoxLock Mic.app" "VoxLock-Mic-$version.zip")
shasum -a 256 "$out/VoxLock-Mic-$version.zip"
