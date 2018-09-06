//
//  AppDelegate.swift
//  Macister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    static let popover = NSPopover()
    var eventMonitor: EventMonitor?
    let hotKey = HotKey(key: .grave, modifiers: [.command])
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Tries to login with saved info.
        let secret = AssetHandler.getAsset(name: ".secrets.json")
        do {
            if secret.exists() {
                let data = secret.getData();
                let json = try JSON(data: data!)
                let schoolJson = json["school"]
                let school = School(url: schoolJson["url"].string!, name: schoolJson["name"].string!, id: schoolJson["id"].string!)
                Magister.magister = Magister(school: school)
                let pass = try EncryptionUtil.decryptMessage(encryptedMessage: json["pass"].string!, encryptionKey: schoolJson["id"].string!);
                Magister.magister!.login(username: json["user"].string!, password: pass, onError: { (str) in
                    Magister.magister = nil
                }, onSucces: {
                    AppDelegate.changeView(controller: MainViewController.vandaagView)
                })
            }
        } catch {}
        AppDelegate.changeView(controller: FindSchoolViewController.freshController())
        
        //Setup Popover
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if AppDelegate.popover.isShown {
                self?.closePopover(sender: event)
            }
        }
        AppDelegate.popover.animates = false
        AppDelegate.popover.appearance = NSAppearance(named: .aqua)
        
        if let button = AppDelegate.statusItem.button {
            button.image = NSImage(named:NSImage.Name("MagisterIcon"))
            button.action = #selector(togglePopover(_:))
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    static func changeView(controller:  NSViewController) {
        DispatchQueue.main.async {
            let newSize = NSSize(width: controller.view.frame.size.width, height: controller.view.frame.size.height)
            popover.contentSize = newSize
            popover.contentViewController = controller
            if let mainController = controller as? MainViewController {
                mainController.update()
            }
        }
    }

    @objc func togglePopover(_ sender: Any?) {
        //Checks if the contentViewController is set, beacuse logging in takes sometime so i may not been set.
        if AppDelegate.popover.contentViewController == nil { return }
        if AppDelegate.popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = AppDelegate.statusItem.button {
            AppDelegate.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        let pw = AppDelegate.popover.contentViewController!.view.window
        pw?.parent?.removeChildWindow(pw!)
        eventMonitor?.start()
        (AppDelegate.popover.contentViewController! as? MainViewController)?.update()
        if hotKey.keyDownHandler == nil {
            hotKey.keyDownHandler = {
                self.togglePopover(self)
            }
        }
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
        ColorPalette.magisterBlack.set()
        __NSRectFill(self.bounds)
    }
}
