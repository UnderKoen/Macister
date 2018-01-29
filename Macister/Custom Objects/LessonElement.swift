//
//  Lesson.swift
//  Macister
//
//  Created by Koen van Staveren on 17/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class LessonElement: NSView {
    @IBOutlet weak var view: NSView!
    
    @IBInspectable var lessonNumber:Int = 0 {
        didSet {
            view.subviews.forEach { (view) in
                if (view.identifier?.rawValue == "LessonNumber") {
                    let lessonNumber = view.subviews[0].subviews[0] as! NSTextField
                    if (self.lessonNumber >= 10) {
                        lessonNumber.font = NSFont.init(name: lessonNumber.font!.fontName, size: 10)
                        lessonNumber.frame = NSRect.init(x: lessonNumber.frame.minX, y: lessonNumber.frame.minY - 2, width: lessonNumber.frame.width, height: lessonNumber.frame.height) 
                    }
                    lessonNumber.stringValue = "\(self.lessonNumber)"
                }
            }
        }
    }
    
    @IBInspectable var lessonTime:String = "" {
        didSet {
            view.subviews.forEach { (view) in
                if (view.identifier?.rawValue == "LessonTime") {
                    let lessonNumber = view as! NSTextField
                    lessonNumber.stringValue = lessonTime
                }
            }
        }
    }
    
    @IBInspectable var lessonInfo:String = "" {
        didSet {
            view.subviews.forEach { (view) in
                if (view.identifier?.rawValue == "LessonInfo") {
                    let lessonNumber = view as! NSTextField
                    lessonNumber.stringValue = lessonInfo
                }
            }
        }
    }
    
    var lesson:Lesson? {
        didSet {
            if ((lesson!.lesuurVan) != nil) {
                lessonNumber = lesson!.lesuurVan!
            }
            if (lesson!.duurtHeleDag ?? false) {
                lessonTime = "0:00 - 0:00"
            } else {
                lessonTime = DateUtil.getLessonTime(lesson: lesson!)
            }
            if ((lesson!.omschrijving) != nil) {
                lessonInfo = lesson!.omschrijving!
            }
        }
    }
    
    var onHover:Bool = false
    override func mouseEntered(with event: NSEvent) {
        onHover = true
        self.layer?.backgroundColor = NSColor(red: 254/255, green: 245/255, blue: 202/255, alpha: 1).cgColor
    }
    
    override func mouseExited(with event: NSEvent) {
        onHover = false
        self.layer?.backgroundColor = nil
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
