//
//  MailElement.swift
//  Macister
//
//  Created by Koen van Staveren on 20/03/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class MailElement: NSView {
    @IBOutlet weak var view: NSView!
    
    var backgroundEl:NSBox!
    var curveEl:NSBox!
    var fromEl:NSTextField!
    var subjectEl:NSTextField!
    var timeEl:NSTextField!
    var infoEl:NSImageView!
    var statusEl:NSBox!
    
    @IBInspectable var from:String! {
        didSet {
            fromEl.stringValue = from
        }
    }
    
    @IBInspectable var subject:String! {
        didSet {
            subjectEl.stringValue = subject
        }
    }
    
    @IBInspectable var time:String! {
        didSet {
            timeEl.stringValue = time
        }
    }
    
    @IBInspectable var bijlage:Bool = false {
        didSet {
            if (bijlage) {
                infoEl.isHidden = false;
                if (selected) {
                    infoEl.image = #imageLiteral(resourceName: "ic_attach_file_white")
                } else {
                    infoEl.image = #imageLiteral(resourceName: "ic_attach_file")
                }
                subjectEl.frame = NSRect(x: subjectEl.frame.minX, y: subjectEl.frame.minY, width: 212, height: subjectEl.frame.height)
            }
        }
    }
    
    @IBInspectable var selected:Bool = false {
        didSet {
            if (selected) {
                self.fromEl.textColor = ColorPalette.whiteTextColor;
                self.subjectEl.textColor = ColorPalette.whiteTextColor;
                self.timeEl.textColor = ColorPalette.whiteTextColor;
                if (oldColor == nil) {
                    oldColor = backgroundEl.fillColor;
                }
                backgroundEl.fillColor = ColorPalette.magisterBlue
                curveEl.fillColor = ColorPalette.magisterBlue
                curveEl.cornerRadius = 4
                self.frame = NSRect(x: self.frame.minX, y: self.frame.minY, width: 258, height: self.frame.height)
                self.bounds = NSRect(x: self.bounds.minX, y: self.bounds.minY, width: 258, height: self.bounds.height)
                self.view.frame = bounds
                self.view.bounds = bounds
                if (bijlage) {
                    infoEl.image = #imageLiteral(resourceName: "ic_attach_file_white")
                }
            } else {
                self.fromEl.textColor = ColorPalette.textColor;
                self.subjectEl.textColor = ColorPalette.textColor;
                self.timeEl.textColor = ColorPalette.textColor;
                if (oldColor != nil) {
                    backgroundEl.fillColor = oldColor;
                }
                curveEl.fillColor = ColorPalette.none
                curveEl.cornerRadius = 0
                self.frame = NSRect(x: self.frame.minX, y: self.frame.minY, width: 252, height: self.frame.height)
                self.bounds = NSRect(x: self.bounds.minX, y: self.bounds.minY, width: 252, height: self.bounds.height)
                self.view.frame = bounds
                self.view.bounds = bounds
                if (bijlage) {
                    infoEl.image = #imageLiteral(resourceName: "ic_attach_file")
                }
            }
        }
    }
    
    @IBInspectable var gelezen:Bool = true {
        didSet {
            if (gelezen) {
                statusEl.fillColor = ColorPalette.none;
                backgroundEl.fillColor = ColorPalette.none;
            } else {
                statusEl.fillColor = ColorPalette.magisterBlue
                backgroundEl.fillColor = statusEl.fillColor.withAlphaComponent(0.15)
            }
        }
    }
    
    var message:Message? {
        didSet {
            if message == nil {
                return
            }
            if message?.mapId == 2 {
                if message?.ontvangersStr != nil {
                    from = message!.ontvangersStr!
                }
            } else {
                if message?.afzender?.naam != nil {
                    from = message!.afzender!.naam!
                }
                
            }
            if message?.onderwerp != nil {
                subject = message!.onderwerp!
            }
            if message?.verstuurdOpDate != nil {
                time = DateUtil.getDateFormatMail().string(from: message!.verstuurdOpDate!)
            }
            if message?.heeftBijlagen != nil && message!.heeftBijlagen ?? false {
                bijlage = message!.heeftBijlagen!
            }
            if message?.isGelezen != nil && !(message!.isGelezen ?? true) {
                gelezen = message!.isGelezen!
            }
        }
    }
    
    var onHover:Bool = false
    var oldColor:NSColor!
    override func mouseEntered(with event: NSEvent) {
        onHover = true
        if (selected) {
            return
        }
        oldColor = backgroundEl.fillColor
        if (oldColor.alphaComponent == 0) {
            backgroundEl.fillColor = ColorPalette.magisterYellow
        } else {
            backgroundEl.fillColor = oldColor.withAlphaComponent(oldColor.alphaComponent + 0.15)
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        onHover = false
        if (selected) {
            return
        }
        backgroundEl.fillColor = oldColor
    }
    
    var onClick:((MailElement) -> ())?
    override func mouseUp(with event: NSEvent) {
        onClick?(self)
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
        view.frame = bounds
        addSubview(view)
        view.subviews.forEach { (el) in
            switch el.identifier!.rawValue {
            case "from":
                fromEl = el as! NSTextField
            case "subject":
                subjectEl = el as! NSTextField
            case "time":
                timeEl = el as! NSTextField
            case "info":
                infoEl = el as! NSImageView
            case "statusColor":
                statusEl = el as! NSBox
            case "background":
                backgroundEl = el as! NSBox
            case "curve":
                curveEl = el as! NSBox
            default:
                break
            }
        }
        self.wantsLayer = true
        self.addTrackingArea(NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
    }
    
    func loadViewFromNib() -> NSView? {
        let bundle = Bundle(for: type(of: self))
        var topLevelObjects: NSArray?
        if bundle.loadNibNamed(NSNib.Name(String(describing: type(of: self))), owner: self, topLevelObjects: &topLevelObjects) {
            return topLevelObjects!.first(where: { $0 is NSView }) as? NSView
        }
        return nil
    }
}

