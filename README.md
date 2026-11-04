# MacCoffee

A menu bar button that stops your Mac from sleeping.

Click the cup in the menu bar and choose **Keep Awake**. The cup fills in while it's on. Choose it again to let the Mac sleep as normal.

## Why it's safe

The whole app is one file, [main.swift](main.swift), about 50 lines long. It only uses Apple's own AppKit (for the menu bar icon) and IOKit power API (the same one `caffeinate` uses). It has no network access, no file access, no keyboard monitoring and no dependencies.

## Build and install

Needs Xcode or the Xcode Command Line Tools.

```sh
./build.sh
open /Applications/MacCoffee.app
```

The app icon is `AppIcon.icns`, drawn by [make-icon.swift](make-icon.swift). To redraw it, run `swift make-icon.swift`.

To start it at login: System Settings → General → Login Items → add MacCoffee.

## Check it's working

```sh
pmset -g assertions | grep MacCoffee
```
