//
//  TodayViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class TodayViewController: MainViewController {

    @IBOutlet weak var calanderItems: NSScrollView!
    @IBOutlet weak var mailItems: NSScrollView!
    @IBOutlet weak var gradeItems: NSScrollView!
    @IBOutlet weak var calenderTop: NSView!
    @IBOutlet weak var mailTop: NSView!
    @IBOutlet weak var gradesTop: NSView!
    @IBOutlet weak var dateLabel: NSTextField!
    
    @IBInspectable var lessonHeight:Int = 48
    
    var calanderDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeek(calanderDate)
        updateCalanderVisual(true)
        update()
    }
    
    @IBAction func nextDay(_ sender: Any) {
        calanderDate.addTimeInterval(86400*7)
        setupWeek(calanderDate)
        updateCalanderVisual(true)
        updateCalander()
    }
    
    @IBAction func previousDay(_ sender: Any) {
        calanderDate.addTimeInterval(-86400*7)
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
    
    //Need to update visual when current day changed TODO
    override func update() {
        updateCalander()
        updateMail()
        updateGrades()
    }
    
    let calendar = Calendar(identifier: .iso8601);
    var week:[Date]!
    var firstTime = true;
    
    func setupWeek(_ day:Date) {
        var date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: day))!
        date = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT(for: date)))
        week = [Date]()
        week.append(date)
        week.append(date.addingTimeInterval(86400))
        week.append(date.addingTimeInterval(86400*2))
        week.append(date.addingTimeInterval(86400*3))
        week.append(date.addingTimeInterval(86400*4))
        week.append(date.addingTimeInterval(86400*5))
        week.append(date.addingTimeInterval(86400*6))
    }
    
    func updateCalanderVisual(_ weekChanged:Bool) {
        let dateFormatter = DateFormatter()
        let dateFormatterDay = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatterDay.dateFormat = "dd"
        for i in 1...7 {
            let date = week[i-1]
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
                }   else {
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
        Magister.magister?.getLessonHandler()?.getLessonsForDay(day: calanderDate, completionHandler: { (lessons) in
            self.calanderItems.documentView!.subviews.forEach({(view) in
                (view as? LessonElement)?.lesson = nil
                view.removeFromSuperview()
            })
            var y:Int = Int(self.calanderItems.frame.height)
            if y-(lessons.count*self.lessonHeight) < 0 {
                self.calanderItems.documentView!.setFrameSize(NSSize(width: self.calanderItems.contentSize.width, height: CGFloat(lessons.count*48)))
                y = lessons.count*self.lessonHeight
            } else {
                self.calanderItems.documentView!.setFrameSize(NSSize(width: self.calanderItems.contentSize.width, height: CGFloat(y)))
            }
            lessons.forEach({ (lesson) in
                y = y-self.lessonHeight
                let el = LessonElement(frame: CGRect(x: 0, y: y, width: 252, height: self.lessonHeight))
                el.lesson = lesson
                self.calanderItems.documentView!.addSubview(el)
            })
            self.calanderItems.documentView!.scroll(NSPoint.init(x: 0, y: lessons.count*self.lessonHeight))
        })
        self.dateLabel.stringValue = DateUtil.getDateFormatToday().string(from: calanderDate)
    }
    
    var mapId = 1
    @IBAction func switchMapId(_ sender: Any) {
        mailTop.subviews.forEach {(view) in
            if !view.subviews[0].isHidden {
                switchButton(view.subviews[1] as! NSButton)
            }
        }
        if let button = sender as? NSButton {
            switch(button.identifier?.rawValue) {
            case "In"?:
                mapId = 1
                break
            case "Out"?:
                mapId = 2
                break
            case "Trash"?:
                mapId = 3
                break
            case "Notifications"?:
                mapId = 4
                break
            default:
                return
            }
            switchButton(button)
        }
        updateMail()
    }
    
    func switchButton(_ button:NSButton) {
        let old = button.image
        let new = button.alternateImage
        button.image = new
        button.alternateImage = old
        let box = button.superview?.subviews[0]
        box?.isHidden = !box!.isHidden
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
                self.mailItems.documentView!.addSubview(el)
            })
            self.mailItems.documentView!.scroll(NSPoint.init(x: 0, y: mail.count*self.lessonHeight))
        })
    }
    
    var average = false
    
    @IBAction func switchGrades(_ sender: Any) {
        gradesTop.subviews.forEach {(view) in
            if !view.subviews[0].isHidden {
                switchButton(view.subviews[1] as! NSButton)
            }
        }
        if let button = sender as? NSButton {
            switch(button.identifier?.rawValue) {
            case "New"?:
                average = false
                break
            case "Average"?:
                average = true
                break
            default:
                return
            }
            switchButton(button)
        }
        updateGrades()
    }
    
    
    func updateGrades() {
        let completionHandler:(Grades?) -> () = { (grades) in
            if (grades != nil) {
                self.gradeItems.documentView!.subviews.forEach({(view) in
                    (view as? GradeElement)?.gradeObj = nil
                    view.removeFromSuperview()
                })
                var y:Int = Int(self.gradeItems.frame.height)
                if y-(grades!.grades!.count*self.lessonHeight) < 0 {
                    self.gradeItems.documentView!.setFrameSize(NSSize(width: self.gradeItems.contentSize.width, height: CGFloat(grades!.grades!.count*48)))
                    y = grades!.grades!.count*self.lessonHeight
                } else {
                    self.calanderItems.documentView!.setFrameSize(NSSize(width: self.calanderItems.contentSize.width, height: CGFloat(y)))
                }
                grades!.grades!.forEach({ (grade) in
                    y = y-self.lessonHeight
                    let el = GradeElement(frame: CGRect(x: 0, y: y, width: 252, height: self.lessonHeight))
                    el.gradeObj = grade
                    if self.average {
                        el.gradeInfoStr = "Gemiddelde"
                    }
                    self.gradeItems.documentView!.addSubview(el)
                })
                self.gradeItems.documentView!.scroll(NSPoint.init(x: 0, y: grades!.grades!.count*self.lessonHeight))
            } else {
                
            }
        }
        if average {
            Magister.magister?.getGradeHandler()?.getAverageGrades(completionHandler: completionHandler)
        } else {
            Magister.magister?.getGradeHandler()?.getLastGrades(completionHandler: completionHandler)
        }
    }
}

extension TodayViewController {
    static func freshController() -> TodayViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Macister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "TodayViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TodayViewController else {
            fatalError("Why cant i find TodayViewController?")
        }
        return viewcontroller
    }
}
