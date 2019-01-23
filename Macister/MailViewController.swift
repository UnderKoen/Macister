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
    @IBOutlet weak var attachments: NSView!
    @IBOutlet weak var attachmentsList: NSScrollView!
    
    @IBInspectable var lessonHeight: Int = 48

    override func viewDidLoad() {
        super.viewDidLoad()
        if (updateId != nil) {
            switchMapId(mailItemsTop.subviews[updateId! - 1])
        }
    }

    var updateId: Int? {
        didSet {
            if (updateId != nil && loaded) {
                switchMapId(mailItemsTop.subviews[updateId! - 1])
            }
        }
    }

    @IBOutlet weak var currentMap: SwitchButton!

    var mapId = 1
    
    @IBAction func switchMapId(_ sender: Any) {
        if let button = sender as? SwitchButton {
            mapId = button.value
            currentMap.active = false
            currentMap = button
            currentMap.active = true
            self.updateMail()
        }
    }

    var height = 532

    func updateBijlagen(_ message: Message?) {
        if (message?.heeftBijlagen ?? false) {
            attachments.isHidden = false
            height = 484
        } else {
            attachments.isHidden = true
            height = 532
        }

        self.attachmentsList.documentView?.subviews.forEach({ (view) in
            (view as? Attachment)?.bijlage = nil
            view.removeFromSuperview()
        })

        let bijlages = message?.bijlages
        if (message?.heeftBijlagen ?? false) {
            var i = 0
            bijlages?.forEach({ (bijlage) in
                var width = Int(Attachment.getWidth(font: NSFont.systemFont(ofSize: 10, weight: .medium), file: bijlage.naam ?? ""))
                if (width > 256) {
                    width = 256
                }
                let att = Attachment(frame: CGRect(x: i, y: 0, width: width, height: 48))
                att.bijlage = bijlage
                att.onClick = { (att) in
                    if (att.bijlage != nil) {
                        Magister.magister?.getMailHandler()?.downloadBijlage(bijlage: att.bijlage!, progressHandler: { (progress) in
                            att.progress = progress.fractionCompleted
                        })
                        .execute()
                    }
                }

                attachmentsList.documentView?.addSubview(att)
                i += width
            })
            attachmentsList.documentView?.setFrameSize(NSSize(width: CGFloat(i + 8), height: attachmentsList.contentSize.height))
        }

        mail.setFrameSize(NSSize(width: self.mail.contentSize.width, height: CGFloat(height)))
    }

    func updateNotifactions() {
        mailItemsTop.subviews.forEach { (view) in
            if let button = view as? SwitchButton {
                let notId = button.value
                Magister.magister?.getMailHandler()?.getUnread(mapId: notId).subscribe(onNext: { amount in
                    button.notifactions = amount
                })
            }
        }
    }

    @IBAction func delete(_ sender: Any) {
        if (selectedMessage == nil) {
            return
        }
        if (mapId == 3) {
            Magister.magister?.getMailHandler()?.deleteMail(message: selectedMessage!).subscribe(onNext: { _ in
                self.unselect()
                self.update()
            })
        } else {
            Magister.magister?.getMailHandler()?.moveMail(message: selectedMessage!, toMapId: 3).subscribe(onNext: { _ in
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
        updateNotifactions()
    }

    @IBOutlet weak var info: NSView!
    @IBOutlet weak var infoButton: SwitchButton!

    var infoState: Bool = false {
        didSet {
            if (oldValue == infoState) {
                return
            }
            infoButton.active = infoState
            info.isHidden = !infoState
            onderwerp.isHidden = infoState
        }
    }

    @IBAction func switchInfo(_ sender: Any) {
        infoState = !infoState
    }

    @IBOutlet weak var onderwerp: NSTextField!
    @IBOutlet weak var afzender: NSTextField!
    @IBOutlet weak var ontvanger: NSTextField!
    @IBOutlet weak var datum: NSTextField!

    let oneLine: NSRect = NSRect.init(x: 8, y: 15, width: 434, height: 18)
    let twoLines: NSRect = NSRect.init(x: 8, y: 6, width: 434, height: 36)

    var selected: Int? {
        didSet {
            if (selected == nil || selectedMessage?.id == selected || mailItems == nil) {
                return
            }
            self.mailItems.documentView!.subviews.forEach({ (view) in
                if let element = view as? MailElement {
                    if (element.message?.id == selected) {
                        updateSelected(element: element)
                    }
                }
            })
        }
    }

    var selectedMessage: Message? {
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
    var oldMessage: MailElement?

    @IBOutlet weak var text: NSTextField!

    func updateText() {
        if (selectedMessage == nil) {
            return
        }
        Magister.magister?.getMailHandler()?.getSingleMail(message: selectedMessage!).subscribe(onNext: { mail in
            self.updateBijlagen(mail)
            
            var html: String = (mail.inhoud ?? "")
            html = html.replacingOccurrences(of: "<p", with: "<div")
            html = html.replacingOccurrences(of: "p>", with: "div>")
            html = html.replacingOccurrences(of: "<div></div>", with: "")

            self.text.attributedStringValue = html.html2AttributedString!

            var h = self.text.attributedStringValue.getHeight(self.text.frame.width)
            if (h < CGFloat(self.height - 32)) {
                h = CGFloat(self.height - 32)
            }

            self.mail.documentView!.setFrameSize(NSSize(width: self.mail.contentSize.width, height: h + 32))
            self.text.frame = NSRect(x: 16, y: 16, width: self.text.frame.width, height: h)
            self.mail.documentView!.scroll(NSPoint(x: 0, y: h + 32))
            if !mail.isGelezen! {
                Magister.magister?.getMailHandler()?.markRead(message: mail, read: true).subscribe(onNext: { _ in
                    self.updateNotifactions()
                })
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

    func updateSelected(element: MailElement) {
        if (element.message == nil) {
            return
        }
        if (oldMessage == element) {
            unselect()
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
        Magister.magister?.getMailHandler()?.getMail(mapId: mapId, top: nil, skip: nil).subscribe(onNext: { mail in
            self.mailItems.documentView!.subviews.forEach({ (view) in
                (view as? MailElement)?.message = nil
                view.removeFromSuperview()
            })
            var y: Int = Int(self.mailItems.frame.height)
            if y - (mail.count * self.lessonHeight) < 0 {
                self.mailItems.documentView!.setFrameSize(NSSize(width: self.mailItems.contentSize.width, height: CGFloat(mail.count * 48)))
                y = mail.count * self.lessonHeight
            } else {
                self.mailItems.documentView!.setFrameSize(NSSize(width: self.mailItems.contentSize.width, height: CGFloat(y)))
            }
            mail.forEach({ (message) in
                y = y - self.lessonHeight
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
            self.mailItems.documentView!.scroll(NSPoint.init(x: 0, y: mail.count * self.lessonHeight))
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
            return nil
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

extension NSAttributedString {
    func getHeight(_ width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading])
        return rect.height
    }
}
