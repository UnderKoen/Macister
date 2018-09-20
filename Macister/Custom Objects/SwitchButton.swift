//
//  SwitchButton.swift
//  Macister
//
//  Created by Koen van Staveren on 06/09/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

@IBDesignable
class SwitchButton: NSControl {
    @IBOutlet var topView: NSView!

    @IBOutlet weak var box: NSBox!
    @IBOutlet weak var button: NSButton!

    @IBInspectable var value: Int = 0
    
    @IBInspectable var active: Bool = false {
        didSet {
            if (oldValue == active) {
                return
            }
            box.isHidden = !active
            button.image = active ? activeImage : inactiveImage
        }
    }

    @IBInspectable var activeImage: NSImage! {
        didSet {
            if (active) {
                button.image = activeImage
            }
        }
    }

    @IBInspectable var inactiveImage: NSImage! {
        didSet {
            if (!active) {
                button.image = inactiveImage
            }
        }
    }

    @IBAction func onPress(_ sender: Any) {
        sendAction(action, to: target)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        let myName = type(of: self).className().components(separatedBy: ".").last!

        if let nib = NSNib(nibNamed: NSNib.Name(rawValue: myName), bundle: Bundle(for: type(of: self))) {
            nib.instantiate(withOwner: self, topLevelObjects: nil)

        }

        addSubview(topView)
        topView.frame = bounds

        self.wantsLayer = true
        self.addTrackingArea(NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
    }
}
