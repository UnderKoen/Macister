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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = AppDelegate.statusItem.button {
            button.image = NSImage(named:NSImage.Name("MagisterIcon"))
            button.action = #selector(togglePopover(_:))
        }
        AppDelegate.popover.contentViewController = FindSchoolViewController.freshController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    static func changeView(controller:  NSViewController) {
        popover.contentViewController = controller
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
    }
    
    func closePopover(sender: Any?) {
        AppDelegate.popover.performClose(sender)
    }

}

