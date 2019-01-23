//
//  LessonElement.swift
//  Macister
//
//  Created by Koen van Staveren on 17/01/2018.
//  Copyright © 2018 Under_Koen. All rights reserved.
//

import Cocoa

@IBDesignable
class LessonElement: NSControl {
    @IBOutlet private var topView: NSView!

    @IBOutlet private weak var time: NSTextField!
    @IBOutlet private weak var lessonE: NSBox!
    @IBOutlet private weak var lessonF: NSTextField!
    @IBOutlet private weak var info: NSTextField!
    @IBOutlet private weak var border: NSBox!
    @IBOutlet private weak var infoTypeE: NSBox!
    @IBOutlet private weak var infoTypeF: NSTextField!
    @IBOutlet private weak var alertBox: NSBox!
    @IBOutlet weak var background: NSBox!
    @IBOutlet weak var curve: NSBox!

    var oldInfoColor: NSColor!
    var oldLessonColor: NSColor!

    @IBInspectable var selected = false {
        didSet {
            if (selected) {
                time.textColor = ColorPalette.whiteTextColor;
                info.textColor = ColorPalette.whiteTextColor;
                if (oldColor == nil) {
                    oldColor = background.fillColor;
                }
                if (alertType == .RED) {
                    background.fillColor = ColorPalette.magisterRed
                    curve.fillColor = ColorPalette.magisterRed
                } else {
                    background.fillColor = ColorPalette.magisterBlue
                    curve.fillColor = ColorPalette.magisterBlue
                }
                oldInfoColor = infoTypeE.fillColor
                infoTypeE.fillColor = ColorPalette.magisterBlack

                oldLessonColor = lessonE.fillColor
                lessonE.fillColor = ColorPalette.magisterBlack
                curve.cornerRadius = 4
                frame = NSRect(x: frame.minX, y: frame.minY, width: 258, height: frame.height)
                bounds = NSRect(x: bounds.minX, y: bounds.minY, width: 258, height: bounds.height)
                topView.frame = bounds
                topView.bounds = bounds
            } else {
                time.textColor = ColorPalette.textColor;
                info.textColor = ColorPalette.textColor;
                if (oldColor != nil) {
                    background.fillColor = oldColor;
                }
                curve.fillColor = ColorPalette.none
                if (oldInfoColor != nil) {
                    infoTypeE.fillColor = oldInfoColor
                }
                if (oldLessonColor != nil) {
                    lessonE.fillColor = oldLessonColor
                }
                curve.cornerRadius = 0
                frame = NSRect(x: frame.minX, y: frame.minY, width: 252, height: frame.height)
                bounds = NSRect(x: bounds.minX, y: bounds.minY, width: 252, height: bounds.height)
                topView.frame = bounds
                topView.bounds = bounds
            }
        }
    }
    
    @IBInspectable var lessonNumber: Int = 0 {
        didSet {
            if (lessonNumber >= 10) {
                lessonF.font = NSFont(name: lessonF.font!.fontName, size: 10)
                lessonF.frame = NSRect(x: lessonF.frame.minX, y: lessonF.frame.minY - 2, width: lessonF.frame.width, height: lessonF.frame.height)
            }
            lessonF.stringValue = "\(lessonNumber)"
            lessonE.isHidden = false
            lessonInfo = String(lessonInfo)
        }
    }
    
    @IBInspectable var lessonTime: String = "" {
        didSet {
            time.stringValue = lessonTime
        }
    }

    @IBInspectable var lessonInfo: String = "" {
        didSet {
            if (lessonE.isHidden) {
                info.frame = NSRect(x: 6, y: info.frame.minY, width: 240, height: info.frame.height)
            } else {
                info.frame = NSRect(x: 28, y: info.frame.minY, width: 218, height: info.frame.height)
            }
            info.stringValue = lessonInfo
        }
    }

    var infoType: InfoType = .NONE {
        didSet {
            if infoType == .NONE || infoType == .ANNOTATION {
                return
            }

            infoTypeF.font = NSFont(name: "DroidSans-Bold", size: 12)
            infoTypeE.isHidden = false
            info.frame = NSRect(x: info.frame.minX, y: info.frame.minY, width: info.frame.width - 32, height: info.frame.height)
            time.frame = NSRect(x: time.frame.minX, y: time.frame.minY, width: time.frame.width - 32, height: time.frame.height)

            switch infoType {
            case .HOMEWORK:
                infoTypeF.stringValue = "HW"
            case .TEST:
                infoTypeF.stringValue = "PW"
            case .EXAM:
                infoTypeF.stringValue = "TT"
            case .QUIZ:
                infoTypeF.stringValue = "SO"
            case .ORAL:
                infoTypeF.stringValue = "MO"
            case .INFORMATION:
                infoTypeF.stringValue = "I"
            default:
                break
            }
        }
    }
    var alertType: Alert = .NONE {
        didSet {
            var color: NSColor!
            switch alertType {
            case .NONE:
                return;
            case .BLUE:
                color = ColorPalette.magisterBlue
            case .RED:
                color = ColorPalette.magisterRed
            }

            alertBox.fillColor = color
            infoTypeE.fillColor = color
            lessonE.fillColor = color
            background.fillColor = color.withAlphaComponent(0.15)
        }
    }

    var lesson: Lesson? {
        didSet {
            if lesson == nil {
                return
            }

            if lesson!.lesuurVan != nil {
                lessonNumber = lesson!.lesuurVan!
            }

            if lesson!.duurtHeleDag ?? false {
                lessonTime = "Hele dag"
            } else {
                lessonTime = DateUtil.getLessonTime(lesson: lesson!)
            }

            if lesson!.omschrijving != nil {
                var string = ""
                if lesson?.lokatie != nil && lesson?.lokatie != "" {
                    string = " (\(lesson!.lokatie!))"
                }
                lessonInfo = lesson!.omschrijving! + string
            }

            if lesson!.infoType != nil {
                infoType = lesson!.infoType!
            }

            if lesson!.lessonType != nil || lesson!.status != nil {
                if lesson!.status == LessonStatusType.CANCELEDAUTOMATICALLY || lesson!.status == LessonStatusType.CANCELEDBYHAND {
                    alertType = .RED
                } else if lesson!.lessonType == LessonType.GENERAL || lesson!.lessonType == LessonType.PERSONAL {
                    alertType = .BLUE
                }
            }
        }
    }

    var onHover: Bool = false
    var oldColor: NSColor!
    
    override func mouseEntered(with event: NSEvent) {
        onHover = true
        if (selected) {
            return
        }
        oldColor = background.fillColor
        if (oldColor.alphaComponent == 0) {
            background.fillColor = ColorPalette.magisterYellow
        } else {
            background.fillColor = oldColor.withAlphaComponent(oldColor.alphaComponent + 0.15)
        }
    }

    override func mouseExited(with event: NSEvent) {
        onHover = false
        if (selected) {
            return
        }
        background.fillColor = oldColor
    }

    var onClick: ((LessonElement) -> ())?

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

    private func setup() {
        let myName = type(of: self).className().components(separatedBy: ".").last!

        if let nib = NSNib(nibNamed: NSNib.Name(rawValue: myName), bundle: Bundle(for: type(of: self))) {
            nib.instantiate(withOwner: self, topLevelObjects: nil)
            
        }

        addSubview(topView)
        topView.frame = bounds

        wantsLayer = true
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
    }
}

enum Alert {
    case NONE
    case BLUE
    case RED
}
