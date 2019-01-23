//
//  CalendarViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class CalendarViewController: MainViewController {
    @IBOutlet weak var calanderItems: NSScrollView!
    @IBOutlet weak var calenderTop: NSView!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var homework: NSScrollView!
    @IBOutlet weak var attachments: NSView!
    @IBOutlet weak var attachmentsList: NSScrollView!
    
    @IBInspectable var lessonHeight: Int = 48

    var calanderDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        if (week == nil) {
            setupWeek(calanderDate)
        }
        updateCalanderVisual(true)
    }
    
    var height = 532
    
    func updateBijlagen(_ lesson: Lesson?) {
        if (lesson?.heeftBijlagen ?? false) {
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
        
        if !(lesson?.heeftBijlagen ?? false) {
            return
        }
        
        let bijlages = lesson?.bijlagen
        if (lesson?.heeftBijlagen ?? false) {
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
                        Magister.magister?.getLessonHandler()?.downloadBijlage(bijlage: att.bijlage!, progressHandler: { (progress) in
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
        
        homework.setFrameSize(NSSize(width: self.homework.contentSize.width, height: CGFloat(height)))
    }

    @IBAction func nextDay(_ sender: Any) {
        calanderDate.addTimeInterval(86400 * 7)
        setupWeek(calanderDate)
        updateCalanderVisual(true)
        updateCalander()
    }

    @IBAction func previousDay(_ sender: Any) {
        calanderDate.addTimeInterval(-86400 * 7)
        setupWeek(calanderDate)
        updateCalanderVisual(true)
        updateCalander()
    }

    @IBAction func toDay(_ sender: Any) {
        if let day = sender as? NSClickGestureRecognizer {
            switch (day.view?.identifier?.rawValue) {
            case "Mo"?:
                calanderDate = week[0]
                break
            case "Tu"?:
                calanderDate = week[1]
                break
            case "We"?:
                calanderDate = week[2]
                break
            case "Th"?:
                calanderDate = week[3]
                break
            case "Fr"?:
                calanderDate = week[4]
                break
            case "Sa"?:
                calanderDate = week[5]
                break
            case "Su"?:
                calanderDate = week[6]
                break
            default:
                return
            }
            updateCalanderVisual(false)
            updateCalander()
        }
    }

    @IBAction func today(_ sender: Any) {
        calanderDate = Date()
        setupWeek(calanderDate)
        updateCalanderVisual(true)
        updateCalander()
    }

    @IBAction func refresh(_ sender: Any) {
        update()
    }

    override func update() {
        updateCalander()
        updateCalanderVisual(true)
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
            omschrijving.isHidden = infoState
        }
    }

    @IBAction func switchInfo(_ sender: Any) {
        infoState = !infoState
    }

    @IBOutlet weak var omschrijving: NSTextField!
    @IBOutlet weak var docent: NSTextField!
    @IBOutlet weak var datum: NSTextField!
    @IBOutlet weak var vak: NSTextField!
    @IBOutlet weak var lokatie: NSTextField!

    let oneLine: NSRect = NSRect.init(x: 8, y: 15, width: 434, height: 18)
    let twoLines: NSRect = NSRect.init(x: 8, y: 6, width: 434, height: 36)

    var selected: Int? {
        didSet {
            if (selected == nil || selectedLesson?.id == selected || calanderItems == nil) {
                return
            }
            self.calanderItems.documentView!.subviews.forEach({ (view) in
                if let element = view as? LessonElement {
                    if (element.lesson?.id == selected) {
                        updateSelected(element: element)
                    }
                }
            })
        }
    }

    var selectedLesson: Lesson? {
        didSet {
            if (selectedLesson == nil) {
                return
            }
            updateText()
            if (selected != selectedLesson?.id) {
                infoState = false
            }
            selected = selectedLesson?.id
            var string = selectedLesson!.omschrijving ?? ""
            if selectedLesson?.lokatie != nil && selectedLesson?.lokatie != "" {
                string = "\(string) (\(selectedLesson!.lokatie!))"
            }
            omschrijving.stringValue = string
            if (omschrijving.attributedStringValue.size().width > omschrijving.frame.width) {
                omschrijving.frame = twoLines
            } else {
                omschrijving.frame = oneLine
            }
            var docenten = ""
            selectedLesson!.docenten?.forEach({ (docent) in
                if (docenten == "") {
                    docenten = docent.naam ?? ""
                } else {
                    if (docent.naam != nil) {
                        docenten = "\(docenten), \(docent.naam!)"
                    }
                }
            })
            docent.stringValue = docenten

            datum.stringValue = DateUtil.getFullLessonTime(lesson: selectedLesson!)

            var vakken = ""
            selectedLesson!.vakken?.forEach({ (vak) in
                if (vakken == "") {
                    vakken = vak.naam ?? ""
                } else {
                    if (vak.naam != nil) {
                        vakken = "\(vakken), \(vak.naam!)"
                    }
                }
            })
            vak.stringValue = vakken

            lokatie.stringValue = selectedLesson!.lokatie ?? ""
        }
    }
    var oldLesson: LessonElement?

    @IBOutlet weak var text: NSTextField!

    func updateText() {
        if (selectedLesson == nil) {
            return
        }
        Magister.magister?.getLessonHandler()?.getLesson(lesson: selectedLesson!).subscribe(onNext: { lesson in
            self.updateBijlagen(lesson)
            
            var html: String = (lesson.inhoud ?? "")
            html = html.replacingOccurrences(of: "<p", with: "<div")
            html = html.replacingOccurrences(of: "p>", with: "div>")
            html = html.replacingOccurrences(of: "<div></div>", with: "")

            self.text.attributedStringValue = html.html2AttributedString!

            var h = self.text.attributedStringValue.getHeight(self.text.frame.width)
            if (h < CGFloat(self.height - 32)) {
                h = CGFloat(self.height - 32)
            }

            self.homework.documentView!.setFrameSize(NSSize(width: self.homework.contentSize.width, height: h + 32))
            self.text.frame = NSRect(x: 16, y: 16, width: self.text.frame.width, height: h)
            self.homework.documentView!.scroll(NSPoint(x: 0, y: h + 32))
        })
    }

    func unselect() {
        oldLesson?.selected = false
        selected = nil
        selectedLesson = nil
        oldLesson = nil
        self.text.stringValue = ""
        self.omschrijving.stringValue = ""
        omschrijving.frame = oneLine
        self.datum.stringValue = ""
        self.docent.stringValue = ""
        self.lokatie.stringValue = ""
        self.vak.stringValue = ""
        infoState = false
    }

    func updateSelected(element: LessonElement) {
        if (element.lesson == nil) {
            return
        }
        if (oldLesson == element) {
            unselect()
            return
        }
        if (oldLesson != nil) {
            oldLesson?.selected = false
        }
        oldLesson = element
        element.selected = true
        selectedLesson = element.lesson!
    }

    let calendar = Calendar(identifier: .iso8601);
    var week: [Date]!
    var firstTime = true;

    func setupWeek(_ day: Date) {
        var date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: day))!
        date = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT(for: date)))
        week = [Date]()

        week.append(date)
        week.append(date.addingTimeInterval(86400))
        week.append(date.addingTimeInterval(86400 * 2))
        week.append(date.addingTimeInterval(86400 * 3))
        week.append(date.addingTimeInterval(86400 * 4))
        week.append(date.addingTimeInterval(86400 * 5))
        week.append(date.addingTimeInterval(86400 * 6))
    }

    func updateCalanderVisual(_ weekChanged: Bool) {
        let dateFormatter = DateFormatter()
        let dateFormatterDay = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatterDay.dateFormat = "dd"
        for i in 1...7 {
            let date = week[i - 1]
            let view = calenderTop.subviews[i]

            let dayLabel = view.subviews[0] as! NSTextField
            let dayOfMonthLabel = view.subviews[2] as! NSTextField
            let box = view.subviews[1] as! NSBox

            let today = Date().timeIntervalSince(date) < 86400 && Date().timeIntervalSince(date) >= 0
            let current = calanderDate.timeIntervalSince(date) < 86400 && calanderDate.timeIntervalSince(date) >= 0

            if firstTime {
                dayLabel.stringValue = String(dateFormatter.string(from: date)[...String.Index(encodedOffset: 1)])
            }

            if weekChanged {
                dayOfMonthLabel.stringValue = dateFormatterDay.string(from: date)
                if today {
                    box.fillColor = ColorPalette.magisterBlue
                } else {
                    box.fillColor = ColorPalette.magisterBlack
                }
            }

            if current {
                box.isHidden = false
                dayOfMonthLabel.textColor = ColorPalette.white
            } else {
                if today {
                    dayOfMonthLabel.textColor = ColorPalette.magisterBlue
                } else {
                    dayOfMonthLabel.textColor = ColorPalette.textLabel
                }
                box.isHidden = true
            }
        }
        self.firstTime = false
    }

    func updateCalander() {
        Magister.magister?.getLessonHandler()?.getLessonsForDay(day: calanderDate).subscribe(onNext: { lessons in
            self.calanderItems.documentView!.subviews.forEach({ (view) in
                (view as? LessonElement)?.lesson = nil
                view.removeFromSuperview()
            })
            var y: Int = Int(self.calanderItems.frame.height)
            if y - (lessons.count * self.lessonHeight) < 0 {
                self.calanderItems.documentView!.setFrameSize(NSSize(width: self.calanderItems.contentSize.width, height: CGFloat(lessons.count * 48)))
                y = lessons.count * self.lessonHeight
            } else {
                self.calanderItems.documentView!.setFrameSize(NSSize(width: self.calanderItems.contentSize.width, height: CGFloat(y)))
            }
            lessons.forEach({ (lesson) in
                y = y - self.lessonHeight
                let el = LessonElement(frame: CGRect(x: 0, y: y, width: 252, height: self.lessonHeight))
                el.lesson = lesson
                if (lesson.id != nil && lesson.id == self.selected) {
                    self.updateSelected(element: el)
                }
                el.onClick = { (element) in
                    self.updateSelected(element: element)
                }

                self.calanderItems.documentView!.addSubview(el)
            })
            self.calanderItems.documentView!.scroll(NSPoint.init(x: 0, y: lessons.count * self.lessonHeight))
        })
        self.dateLabel.stringValue = DateUtil.getDateFormatToday().string(from: calanderDate)
    }
}

extension CalendarViewController {
    static func freshController() -> CalendarViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Macister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "CalendarViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CalendarViewController else {
            fatalError("Why cant i find CalendarViewController?")
        }
        return viewcontroller
    }
}
