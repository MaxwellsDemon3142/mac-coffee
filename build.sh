#!/bin/sh
# Builds MacCoffee.app from main.swift and copies it to /Applications.
set -e
cd "$(dirname "$0")"

APP=MacCoffee.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp AppIcon.icns "$APP/Contents/Resources/"

# Pin a minimum macOS so the app runs on this Mac even when the SDK is newer.
swiftc -O -target "$(uname -m)-apple-macos13.0" main.swift -o "$APP/Contents/MacOS/MacCoffee"

cat > "$APP/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleExecutable</key><string>MacCoffee</string>
	<key>CFBundleIconFile</key><string>AppIcon</string>
	<key>CFBundleIdentifier</key><string>local.maccoffee</string>
	<key>CFBundleName</key><string>MacCoffee</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>CFBundleShortVersionString</key><string>1.0</string>
	<key>LSMinimumSystemVersion</key><string>13.0</string>
	<key>LSUIElement</key><true/>
</dict>
</plist>
EOF

codesign --force --sign - "$APP"
rm -rf "/Applications/$APP"
cp -R "$APP" /Applications/
echo "Installed /Applications/$APP"
