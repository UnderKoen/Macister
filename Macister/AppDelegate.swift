//
//  AppDelegate.swift
//  Macister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    static let popover = NSPopover()
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = AppDelegate.statusItem.button {
            button.image = NSImage(named:NSImage.Name("MagisterIcon"))
            button.action = #selector(togglePopover(_:))
        }
        AppDelegate.popover.contentViewController = FindSchoolViewController.freshController()
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if AppDelegate.popover.isShown {
                self?.closePopover(sender: event)
            }
        }
        AppDelegate.popover.animates = false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    static func changeView(controller:  NSViewController) {
        DispatchQueue.main.async {
            let newSize = NSSize.init(width: controller.view.frame.size.width, height: controller.view.frame.size.height)
            popover.contentSize = newSize
            popover.contentViewController = controller
        }
    }

    @objc func togglePopover(_ sender: Any?) {
        if  AppDelegate.popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = AppDelegate.statusItem.button {
            AppDelegate.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        AppDelegate.popover.performClose(sender)
        eventMonitor?.stop()
    }

}

class PopoverContentView:NSView {
    var backgroundView:PopoverBackgroundView?
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if let frameView = self.window?.contentView?.superview {
            if backgroundView == nil {
                backgroundView = PopoverBackgroundView(frame: frameView.bounds)
                frameView.addSubview(backgroundView!, positioned: NSWindow.OrderingMode.below, relativeTo: frameView)
            }
        }
    }
}

class PopoverBackgroundView:NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1).set()
        __NSRectFill(self.bounds)
    }
}
