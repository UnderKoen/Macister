//
//  GradeElement.swift
//  Macister
//
//  Created by Koen van Staveren on 05/02/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//test

import Foundation
import Cocoa

@IBDesignable
class GradeElement: NSView {
    @IBOutlet weak var view: NSView!

    var gradeEl: NSBox!
    var gradeSubject: NSTextField!
    var gradeInfo: NSTextField!

    @IBInspectable var grade: String = "" {
        didSet {
            let gradeLabel = gradeEl.contentView!.subviews[0] as! NSTextField
            gradeLabel.font = NSFont.init(name: "DroidSans-Bold", size: 12)
            gradeLabel.stringValue = grade
        }
    }

    @IBInspectable var gradeSubjectStr: String = "" {
        didSet {
            gradeSubject.stringValue = gradeSubjectStr
        }
    }

    @IBInspectable var gradeInfoStr: String = "" {
        didSet {
            gradeInfo.stringValue = gradeInfoStr
        }
    }

    @IBInspectable var isFail: Bool = false {
        didSet {
            if (isFail) {
                gradeEl.fillColor = ColorPalette.magisterRed
            }
        }
    }

    var gradeObj: Grade? {
        didSet {
            if gradeObj == nil {
                return
            }
            if gradeObj!.cijferStr != nil {
                grade = gradeObj!.cijferStr!
            }
            if gradeObj!.isVoldoende != nil {
                isFail = !gradeObj!.isVoldoende!
            }
            if gradeObj!.vak?.naam != nil {
                gradeSubjectStr = gradeObj!.vak!.naam!
            }
            if gradeObj!.omschrijving != nil {
                gradeInfoStr = gradeObj!.omschrijving!
            }
        }
    }

    var onHover: Bool = false

    override func mouseEntered(with event: NSEvent) {
        onHover = true
        self.layer?.backgroundColor = ColorPalette.magisterYellow.cgColor
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
        view.subviews.forEach { (el) in
            switch el.identifier!.rawValue {
            case "grade":
                gradeEl = el as! NSBox
            case "gradeInfo":
                gradeInfo = el as! NSTextField
            case "gradeSubject":
                gradeSubject = el as! NSTextField
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
