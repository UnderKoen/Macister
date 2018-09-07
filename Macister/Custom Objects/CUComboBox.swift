//
//  CUComboBox.swift
//  Macister
//
//  Created by Koen van Staveren on 01/02/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class CUComboBox: CUTextField {
    var button: NSButton!
    var popoverView: NSScrollView!
    var items: [NSObject] = []
    var itemsView: [NSView] = []
    var selectedItem: Int = -1 {
        didSet {
            if (selectedItem >= 0) {
                input.stringValue = items[selectedItem].description
            }
        }
    }

    @IBInspectable var heightForItem: Int = 20 {
        didSet {
            update()
        }
    }

    @IBInspectable var maxItems: Int = 5 {
        didSet {
            update()
        }
    }

    override func setup() {
        super.setup()
        view.subviews.forEach { (view) in
            switch (view.identifier!.rawValue) {
            case "button":
                button = view as! NSButton
            default:
                break
            }
        }
        let bundle = Bundle(for: type(of: self))
        var topLevelObjects: NSArray?
        if bundle.loadNibNamed(NSNib.Name(String(describing: type(of: self))), owner: self, topLevelObjects: &topLevelObjects) {
            popoverView = topLevelObjects!.first(where: { (view) in
                return (view as? NSView)?.identifier?._rawValue ?? "" == "popover"
            }) as! NSScrollView
        }
        popoverView.shadow = NSShadow()
        popoverView.layer!.shadowOpacity = 1
        popoverView.layer!.shadowOffset = CGSize(width: 0.0, height: 2.0)
        popoverView.layer!.shadowRadius = 6
        button.action = #selector(onclick)
        update()
    }

    func addItem(item: NSObject) {
        items.append(item)
        update()
    }

    func addItems(item: [NSObject]) {
        item.forEach { (obj) in
            items.append(obj)
        }
        update()
    }

    func removeAll() {
        items.removeAll()
        itemsView.forEach { (view) in
            view.removeFromSuperview()
        }
        update()
    }

    override func controlTextDidChange(_ obj: Notification) {
        super.controlTextDidChange(obj)
        selectedItem = -1
        if (items.count > 0 && !popoverActive) || (items.count == 0 && popoverActive) {
            onclick("")
        }
    }

    func update() {
        self.superview?.addSubview(popoverView)
        var amount = items.count
        if amount == 0 {
            amount = 1
        }
        if amount <= maxItems {
            popoverView.frame = NSRect(x: frame.minX, y: frame.minY - CGFloat(amount * heightForItem), width: bounds.width, height: CGFloat(amount * heightForItem))
        } else {
            popoverView.frame = NSRect(x: frame.minX, y: frame.minY - CGFloat(maxItems * heightForItem), width: bounds.width, height: CGFloat(maxItems * heightForItem))
        }
        popoverView.documentView!.setFrameSize(NSSize(width: Int(bounds.width), height: amount * heightForItem))
        popoverView.backgroundColor = ColorPalette.white
        var height: CGFloat = CGFloat((amount - 1) * heightForItem)
        var i = 0
        items.forEach { (obj) in
            let text = TextFieldClick.init(frame: NSRect(x: 0.0, y: height, width: popoverView.frame.width, height: CGFloat(heightForItem)))
            text.isEditable = false
            text.stringValue = obj.description
            text.isBordered = false
            text.font = NSFont.init(name: text.font!.fontName, size: CGFloat(heightForItem / 2 + 4))
            text.textColor = ColorPalette.black
            popoverView.documentView!.addSubview(text)
            height -= CGFloat(heightForItem)
            let id = i
            text.backgroundColor = ColorPalette.white
            text.onClick = { () in
                self.selectedItem = id
                self.popoverView.isHidden = true
                self.button.image = #imageLiteral(resourceName: "ic_expand_more")
                self.popoverActive = false
            }
            itemsView.append(text)
            i += 1
        }
        popoverView.documentView!.scroll(NSPoint(x: 0, y: amount * heightForItem))
        if (items.count > 0 && !popoverActive) || (items.count == 0 && popoverActive) {
            onclick("")
        }
    }

    var popoverActive: Bool = false

    @objc func onclick(_ sender: Any?) {
        if (popoverActive) {
            popoverView.isHidden = true
            button.image = #imageLiteral(resourceName: "ic_expand_more")
            popoverActive = false
        } else {
            popoverView.isHidden = false
            button.image = #imageLiteral(resourceName: "ic_expand_less")
            popoverActive = true
        }
    }
}
