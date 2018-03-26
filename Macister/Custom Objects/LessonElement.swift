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
    
    var activeLN = false
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
                    view.isHidden = false
                    activeLN = true
                    lessonInfo = String(lessonInfo)
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
                    if (activeLN) {
                        lessonNumber.frame = NSRect(x: 28, y: lessonNumber.frame.minY, width: 186, height: lessonNumber.frame.height)
                    } else {
                        lessonNumber.frame = NSRect(x: 6, y: lessonNumber.frame.minY, width: 208, height: lessonNumber.frame.height)
                    }
                    lessonNumber.stringValue = lessonInfo
                }
            }
        }
    }
    
    var infoType:InfoType = .NONE {
        didSet {
            view.subviews.forEach { (view) in
                if (view.identifier?.rawValue == "InfoType") {
                    let infoTypeLabel = view.subviews[0].subviews[0] as! NSTextField
                    infoTypeLabel.font = NSFont.init(name: "DroidSans-Bold", size: 12)
                    switch self.infoType {
                    case .NONE:
                        break
                    case .HOMEWORK:
                        view.isHidden = false
                        infoTypeLabel.stringValue = "HW"
                    case .TEST:
                        view.isHidden = false
                        infoTypeLabel.stringValue = "PW"
                    case .EXAM:
                        view.isHidden = false
                        infoTypeLabel.stringValue = "TT"
                    case .QUIZ:
                        view.isHidden = false
                        infoTypeLabel.stringValue = "SO"
                    case .ORAL:
                        view.isHidden = false
                        infoTypeLabel.stringValue = "MO"
                    case .INFORMATION:
                        view.isHidden = false
                        infoTypeLabel.stringValue = "I"
                    case .ANNOTATION:
                        break
                    }
                }
            }
        }
    }
    
    var alertType:Alert = .NONE {
        didSet {
            view.subviews.forEach { (view) in
                if (view.identifier?.rawValue == "statusColor" || view.identifier?.rawValue == "LessonNumber") {
                    let box = view as! NSBox
                    var color:NSColor? = nil
                    switch self.alertType {
                    case .NONE:
                        break
                    case .BLUE:
                        color = ColorPalette.magisterBlue
                    case .RED:
                        color = ColorPalette.magisterRed
                    }
                    if color != nil {
                        box.fillColor = color!
                        self.layer?.backgroundColor = color!.withAlphaComponent(0.15).cgColor
                    }
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
                lessonTime = "Hele dag"
            } else {
                lessonTime = DateUtil.getLessonTime(lesson: lesson!)
            }
            if ((lesson!.omschrijving) != nil) {
                var string = ""
                if (lesson?.lokatie != nil && lesson?.lokatie != "") {
                    string = " (\(lesson!.lokatie!))"
                }
                lessonInfo = lesson!.omschrijving! + string
            }
            if (lesson!.infoType != nil) {
                self.infoType = lesson!.infoType!
            }
            if (lesson!.lessonType != nil || lesson!.status != nil) {
                if lesson!.status == LessonStatusType.CANCELEDAUTOMATICALLY || lesson!.status == LessonStatusType.CANCELEDBYHAND {
                    alertType = .RED
                } else if lesson!.lessonType == LessonType.GENERAL || lesson!.lessonType == LessonType.PERSONAL {
                    alertType = .BLUE
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
            self.layer?.backgroundColor = ColorPalette.magisterYellow.cgColor
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

enum Alert {
    case NONE
    case BLUE
    case RED
}
