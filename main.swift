// MacCoffee: a menu bar button that stops the Mac from sleeping.
// Uses only Apple's AppKit and IOKit power APIs. No network, no files, no keyboard access.

import AppKit
import IOKit.pwr_mgt

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let toggleItem = NSMenuItem(title: "Keep Awake", action: #selector(toggle), keyEquivalent: "")
    private var assertionID: IOPMAssertionID = 0
    private var isAwake = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        let menu = NSMenu()
        toggleItem.target = self
        menu.addItem(toggleItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit MacCoffee", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
        updateUI()
    }

    @objc private func toggle() {
        if isAwake {
            IOPMAssertionRelease(assertionID)
            isAwake = false
        } else {
            // Stops both display sleep and idle system sleep, like `caffeinate -d`.
            isAwake = IOPMAssertionCreateWithName(
                kIOPMAssertionTypeNoDisplaySleep as CFString,
                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                "MacCoffee is keeping the Mac awake" as CFString,
                &assertionID
            ) == kIOReturnSuccess
        }
        updateUI()
    }

    private func updateUI() {
        let symbol = isAwake ? "cup.and.saucer.fill" : "cup.and.saucer"
        statusItem.button?.image = NSImage(systemSymbolName: symbol, accessibilityDescription: "MacCoffee")
        toggleItem.state = isAwake ? .on : .off
    }

    func applicationWillTerminate(_ notification: Notification) {
        if isAwake { IOPMAssertionRelease(assertionID) }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
