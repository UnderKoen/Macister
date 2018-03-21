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
    
    @IBInspectable var info:NSImage! {
        didSet {
            infoEl.isHidden = false;
            infoEl.image = info
            subjectEl.frame = NSRect(x: subjectEl.frame.minX, y: subjectEl.frame.minY, width: 212, height: subjectEl.frame.height)
        }
    }
    
    var message:Message? {
        didSet {
            if message?.afzender?.naam != nil {
                from = message!.afzender!.naam!
            }
            if message?.onderwerp != nil {
                subject = message!.onderwerp!
            }
            if message?.verstuurdOpDate != nil {
                time = DateUtil.getDateFormatMail().string(from: message!.verstuurdOpDate!)
            }
            if message?.heeftBijlagen != nil {
                if message!.heeftBijlagen! {
                    info = #imageLiteral(resourceName: "ic_attach_file")
                }
            }
            if message?.isGelezen != nil {
                if !message!.isGelezen! {
                    statusEl.fillColor = NSColor(red: 0/255, green: 147/255, blue: 226/255, alpha: 1)
                    self.layer?.backgroundColor = statusEl.fillColor.withAlphaComponent(0.15).cgColor
                }
            }
        }
    }
    
    var onHover:Bool = false
    var oldColor:CGColor?
    override func mouseEntered(with event: NSEvent) {
        onHover = true
        oldColor = self.layer?.backgroundColor
        if (oldColor == nil) {
            self.layer?.backgroundColor = NSColor(red: 254/255, green: 245/255, blue: 202/255, alpha: 1).cgColor
        } else {
            self.layer?.backgroundColor = NSColor.init(cgColor: oldColor!)?.withAlphaComponent(0.3).cgColor
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        onHover = false
        self.layer?.backgroundColor = oldColor
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

