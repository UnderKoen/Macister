//
//  Attachment.swift
//  Macister
//
//  Created by Koen van Staveren on 12/11/2018.
//  Copyright © 2018 Under_Koen. All rights reserved.
//

import Cocoa

@IBDesignable
class Attachment: NSView {
    @IBOutlet var topView: NSView!

    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var fileName: NSTextField!
    @IBOutlet weak var background: NSBox!
    @IBOutlet weak var bar: NSBox!

    var onClick: ((Attachment) -> ())?

    @IBAction func onPress(_ sender: Any) {
        onClick?(self)
    }

    var bijlage: Bijlage? {
        didSet {
            if (bijlage != nil) {
                self.file = bijlage?.naam ?? ""
                self.fileType = String(file.split(separator: ".").last ?? "")
            }
        }
    }

    var progress: Double? {
        didSet {
            if (progress == nil) {
                background.fillColor = ColorPalette.magisterBlack.withAlphaComponent(0.1)
            } else {
                if (progress == 1.0) {
                    background.fillColor = ColorPalette.magisterGreen.withAlphaComponent(0.5)
                    bar.isHidden = true
                } else {
                    background.fillColor = ColorPalette.magisterBlack.withAlphaComponent(0.1)
                    bar.isHidden = false
                    bar.setFrameSize(NSSize(width: (background.frame.width) * CGFloat(progress!), height: bar.frame.height))
                }
            }
        }
    }

    var ugh: Bool = true
    @IBInspectable var file: String! {
        didSet {
            fileName.stringValue = file
        }
    }

    @IBInspectable var fileType: String! {
        didSet {
            image.image = NSWorkspace.shared.icon(forFileType: fileType)
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

    public static func getWidth(font: NSFont, file: String) -> CGFloat {
        let toAdd = CGFloat(48)

        let font = font

        let spaceWidth = " ".width(font: font)
        let half = ceil(file.width(font: font) / 2)

        let pieces = file.split(separator: " ")
        var total = CGFloat(0)

        for str in pieces {
            let string = String(str)
            if (total >= half) {
                let w = string.width(font: font)
                if (w > total - spaceWidth) {
                    total = w
                }
                total += 1 + spaceWidth
                break
            }

            total += string.width(font: font)
            if (total >= half) {
                total += 1 + spaceWidth
                break
            }
            total += spaceWidth
        }

        return toAdd + total
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

extension String {
    func width(font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
