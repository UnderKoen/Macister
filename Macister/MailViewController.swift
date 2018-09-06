//
//  SpecialViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 18/05/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class MailViewController: MainViewController {
    @IBOutlet weak var mailItems: NSScrollView!
    @IBOutlet weak var mailItemsTop: NSView!
    @IBOutlet weak var mail: NSScrollView!
    
    @IBInspectable var lessonHeight:Int = 48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (updateId != nil) {
            mapId = updateId!
        }
    }
    
    var updateId:Int? {
        didSet {
            if (updateId != nil && loaded) {
                mapId = updateId!
            }
        }
    }
    var mapId = 1 {
        didSet {
            if (oldValue == self.mapId) {
                return
            }
            if let button = mailItemsTop?.subviews[oldValue - 1].subviews[1] as? NSButton {
                switchButton(button)
            }
            
            if let button = mailItemsTop?.subviews[mapId - 1].subviews[1] as? NSButton {
                switchButton(button)
            }
        }
    }
    
    @IBAction func switchMapId(_ sender: Any) {
        if let button = sender as? NSButton {
            switch(button.identifier?.rawValue) {
            case "Mail_In"?:
                mapId = 1
                break
            case "Mail_Out"?:
                mapId = 2
                break
            case "Mail_Trash"?:
                mapId = 3
                break
            case "Mail_Notifications"?:
                mapId = 4
                break
            default:
                return
            }
            self.update()
        }
    }
    
    @IBAction func delete(_ sender: Any) {
        if (selectedMessage == nil) {
            return
        }
        if (mapId == 3) {
            Magister.magister?.getMailHandler()?.deleteMail(message: selectedMessage!, completionHandler: {
                self.unselect()
                self.update()
            })
        } else {
            Magister.magister?.getMailHandler()?.moveMail(message: selectedMessage!, toMapId: 3, completionHandler: { (mail) in
                self.unselect()
                self.update()
            })
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        update()
    }
    
    override func update() {
        updateMail()
    }
    
    @IBOutlet weak var info: NSView!
    @IBOutlet weak var infoButton: NSButton!
    
    var infoState:Bool = false {
        didSet {
            if (oldValue == infoState) {
                return
            }
            switchButton(infoButton)
            info.isHidden = !infoState
            onderwerp.isHidden = infoState
        }
    }
    @IBAction func switchInfo(_ sender: Any) {
        if sender is NSButton {
            infoState = !infoState
        }
    }
    
    
    func switchButton(_ button:NSButton) {
        let old = button.image
        let new = button.alternateImage
        button.image = new
        button.alternateImage = old
        let box = button.superview?.subviews[0]
        box?.isHidden = !box!.isHidden
    }
    
    @IBOutlet weak var onderwerp: NSTextField!
    @IBOutlet weak var afzender: NSTextField!
    @IBOutlet weak var ontvanger: NSTextField!
    @IBOutlet weak var datum: NSTextField!
    
    let oneLine:NSRect = NSRect.init(x: 8, y: 15, width: 434, height: 18)
    let twoLines:NSRect = NSRect.init(x: 8, y: 6, width: 434, height: 36)
    
    var selected:Int? {
        didSet {
            if (selected == nil || selectedMessage?.id == selected || mailItems == nil) {
                return
            }
            self.mailItems.documentView!.subviews.forEach({(view) in
                if let element = view as? MailElement {
                    if (element.message?.id == selected) {
                        updateSelected(element: element)
                    }
                }
            })
        }
    }
    
    var selectedMessage:Message? {
        didSet {
            if (selectedMessage == nil) {
                return
            }
            updateText()
            if (selected != selectedMessage?.id) {
                infoState = false
            }
            selected = selectedMessage?.id
            onderwerp.stringValue = selectedMessage!.onderwerp ?? ""
            if (onderwerp.attributedStringValue.size().width > onderwerp.frame.width) {
                onderwerp.frame = twoLines
            } else {
                onderwerp.frame = oneLine
            }
            afzender.stringValue = selectedMessage!.afzender?.naam ?? ""
            ontvanger.stringValue = selectedMessage!.ontvangersStr ?? ""
            if (selectedMessage!.verstuurdOpDate != nil) {
                datum.stringValue = DateUtil.getFullDateFormatMail().string(from: selectedMessage!.verstuurdOpDate!)
            } else {
                datum.stringValue = ""
            }
        }
    }
    var oldMessage:MailElement?
    
    @IBOutlet weak var text: NSTextField!
    func updateText() {
        if (selectedMessage == nil) {
            return
        }
        Magister.magister?.getMailHandler()?.getSingleMail(message: selectedMessage!, completionHandler: { (mail) in
            var html:String = (mail.inhoud ?? "")
            html = html.replacingOccurrences(of: "<p", with: "<div")
            html = html.replacingOccurrences(of: "p>", with: "div>")
            html = html.replacingOccurrences(of: "<div></div>", with: "")
            
            self.text.attributedStringValue = html.html2AttributedString!
            
            var h:CGFloat = self.text.attributedStringValue.size().height
            if (h < 500) {
                h = 500
            }
            self.mail.documentView!.setFrameSize(NSSize(width: self.mail.contentSize.width, height: h + 32))
            self.text.frame = NSRect(x: 16, y: 16, width: self.text.frame.width, height: h)
            self.mail.documentView!.scroll(NSPoint(x: 0, y: h + 32))
            if !mail.isGelezen! {
                Magister.magister?.getMailHandler()?.markRead(message: mail, read: true)
            }
        })
    }
    
    func unselect() {
        oldMessage?.selected = false
        selected = nil
        selectedMessage = nil
        oldMessage = nil
        self.text.stringValue = ""
        self.onderwerp.stringValue = ""
        onderwerp.frame = oneLine
        self.afzender.stringValue = ""
        self.ontvanger.stringValue = ""
        self.datum.stringValue = ""
        infoState = false
    }
    
    func updateSelected(element:MailElement) {
        if (element.message == nil || oldMessage == element) {
            return
        }
        if (oldMessage != nil) {
            oldMessage?.selected = false
            oldMessage?.gelezen = true
        }
        oldMessage = element
        element.selected = true
        selectedMessage = element.message!
    }
    
    func updateMail() {
        Magister.magister?.getMailHandler()?.getMail(mapId: mapId, top: nil, skip: nil, completionHandler: { (mail) in
            self.mailItems.documentView!.subviews.forEach({(view) in
                (view as? MailElement)?.message = nil
                view.removeFromSuperview()
            })
            var y:Int = Int(self.mailItems.frame.height)
            if y-(mail.count*self.lessonHeight) < 0 {
                self.mailItems.documentView!.setFrameSize(NSSize(width: self.mailItems.contentSize.width, height: CGFloat(mail.count*48)))
                y = mail.count*self.lessonHeight
            } else {
                self.mailItems.documentView!.setFrameSize(NSSize(width: self.mailItems.contentSize.width, height: CGFloat(y)))
            }
            mail.forEach({ (message) in
                y = y-self.lessonHeight
                let el = MailElement(frame: CGRect(x: 0, y: y, width: 252, height: self.lessonHeight))
                el.message = message
                if (message.id != nil && message.id == self.selected) {
                    self.updateSelected(element: el)
                }
                el.onClick = { (element) in
                    self.updateSelected(element: element)
                }
                
                self.mailItems.documentView!.addSubview(el)
            })
            self.mailItems.documentView!.scroll(NSPoint.init(x: 0, y: mail.count*self.lessonHeight))
        })
    }
}

extension MailViewController {
    static func freshController() -> MailViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Macister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "MailViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MailViewController else {
            fatalError("Why cant i find MailViewController?")
        }
        return viewcontroller
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
