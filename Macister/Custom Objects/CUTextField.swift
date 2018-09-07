//
//  CUTextField.swift
//  Macister
//
//  Created by Koen van Staveren on 31/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class CUTextField: NSView, NSTextFieldDelegate {
    @IBOutlet var view: NSView!
    var inputId = "input"
    var input: NSTextField!
    var inputClick: ClickField!
    var label: NSTextField!
    var line: NSBox!

    var active = false

    @IBInspectable var secure: Bool = false {
        didSet {
            let secureInput = view.subviews.first(where: { (view) -> Bool in
                view.identifier!.rawValue == "secureInput"
            }) as! NSTextField
            let notSecure = view.subviews.first(where: { (view) -> Bool in
                view.identifier!.rawValue == "input"
            }) as! NSTextField
            if (secure) {
                secureInput.isHidden = false
                notSecure.isHidden = true
                input = secureInput
            } else {
                secureInput.isHidden = true
                notSecure.isHidden = false
                input = notSecure
            }
            setupInput(input: input)
        }
    }

    @IBInspectable var activeColor: NSColor = ColorPalette.magisterBlue {
        didSet {
            if (active) {
                label.textColor = activeColor
            }
        }
    }

    @IBInspectable var notActiveColor: NSColor = ColorPalette.notActiveLabel {
        didSet {
            if (!active) {
                label.textColor = notActiveColor
            }
        }
    }

    @IBInspectable var inputColor: NSColor = ColorPalette.black {
        didSet {
            input.textColor = inputColor
        }
    }

    @IBInspectable var labelText: String = "" {
        didSet {
            label.stringValue = labelText
        }
    }

    @IBInspectable var title: String = "" {
        didSet {
            if (title != "") {
                input.stringValue = title
                self.animate(duration: 0, oldPos: self.label.frame, newPos: self.label.frame.offsetBy(dx: 0, dy: 24), oldFont: self.label.font!, newFont: NSFont(name: self.label.font!.fontName, size: 12)!, oldColor: self.notActiveColor, newColor: self.activeColor)
                self.active = true
            }
        }
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
        view = loadViewFromNib()
        addSubview(view)
        view.frame = bounds
        self.wantsLayer = true
        view.subviews.forEach { (view) in
            switch (view.identifier!.rawValue) {
            case "input":
                input = view as! NSTextField
            case "label":
                label = view as! NSTextField
            case "line":
                line = view as! NSBox
            default:
                break
            }
        }
        setupInput(input: input)
    }

    func setupInput(input: NSTextField) {
        input.delegate = self
        var clickfield = input as! ClickField
        clickfield.onClick = { () in
            if (!self.active) {
                self.active = true
                self.animate(duration: 0.2, oldPos: self.label.frame, newPos: self.label.frame.offsetBy(dx: 0, dy: 24), oldFont: self.label.font!, newFont: NSFont(name: self.label.font!.fontName, size: 12)!, oldColor: self.notActiveColor, newColor: self.activeColor)
            }
        }
    }

    override func controlTextDidBeginEditing(_ obj: Notification) {
        if (!self.active) {
            self.active = true
            self.animate(duration: 0.2, oldPos: self.label.frame, newPos: self.label.frame.offsetBy(dx: 0, dy: 24), oldFont: self.label.font!, newFont: NSFont(name: self.label.font!.fontName, size: 12)!, oldColor: self.notActiveColor, newColor: self.activeColor)
        }
    }

    override func controlTextDidEndEditing(_ obj: Notification) {
        if (input.stringValue == "" && active) {
            active = false
            self.animate(duration: 0.2, oldPos: self.label.frame, newPos: self.label.frame.offsetBy(dx: 0, dy: -24), oldFont: self.label.font!, newFont: NSFont(name: self.label.font!.fontName, size: 16)!, oldColor: self.activeColor, newColor: self.notActiveColor)
        }
    }

    var controlTextDidChange: (_ obj: Notification) -> () = { (obj) in
    }

    override func controlTextDidChange(_ obj: Notification) {
        controlTextDidChange(obj)
    }

    func animate(duration: CGFloat, oldPos: NSRect, newPos: NSRect, oldFont: NSFont, newFont: NSFont, oldColor: NSColor, newColor: NSColor) {
        var i: CGFloat = 0.0
        let iTime: CGFloat = duration
        let iMax: CGFloat = 60.0 * iTime
        DispatchQueue.global().async {
            while i < iMax {
                i += 1.0
                DispatchQueue.main.async {
                    self.label.frame = self.label.frame.offsetBy(dx: (newPos.minX - oldPos.minX) / iMax, dy: (newPos.minY - oldPos.minY) / iMax)
                    self.label.font = NSFont.init(name: self.label.font!.fontName, size: self.label.font!.pointSize + (newFont.pointSize - oldFont.pointSize) / iMax)
                    self.label.textColor = NSColor.init(red: self.label.textColor!.redComponent + (newColor.redComponent - oldColor.redComponent) / iMax, green: self.label.textColor!.greenComponent + (newColor.greenComponent - oldColor.greenComponent) / iMax, blue: self.label.textColor!.blueComponent + (newColor.blueComponent - oldColor.blueComponent) / iMax, alpha: 1)
                    self.line.fillColor = NSColor.init(red: self.line.fillColor.redComponent + (newColor.redComponent - oldColor.redComponent) / iMax, green: self.line.fillColor.greenComponent + (newColor.greenComponent - oldColor.greenComponent) / iMax, blue: self.line.fillColor.blueComponent + (newColor.blueComponent - oldColor.blueComponent) / iMax, alpha: 1)
                }
                usleep(useconds_t(1000000.0 * iTime / iMax))
            }
            DispatchQueue.main.async {
                self.label.frame = newPos
                self.label.font = newFont
                self.label.textColor = newColor
                self.line.fillColor = newColor
            }
        }
    }

    func loadViewFromNib() -> NSView? {
        let bundle = Bundle(for: type(of: self))
        var topLevelObjects: NSArray?
        if bundle.loadNibNamed(NSNib.Name(String(describing: type(of: self))), owner: self, topLevelObjects: &topLevelObjects) {
            return topLevelObjects!.first(where: { (view) in
                return view is NSView && (view as? NSView)?.identifier?._rawValue ?? "" == "view"
            }) as? NSView
        }
        return nil
    }
}

protocol ClickField {
    var onClick: () -> () { get set }
}

class TextFieldClick: NSTextField, ClickField {
    var onClick: () -> () = { () in
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func mouseDown(with event: NSEvent) {
        onClick()
    }
}

class SecureTextFieldClick: NSSecureTextField, ClickField {
    var onClick: () -> () = { () in
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func mouseDown(with event: NSEvent) {
        onClick()
    }
}
