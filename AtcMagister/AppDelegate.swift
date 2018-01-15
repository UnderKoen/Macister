//
//  AppDelegate.swift
//  AtcMagister
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

