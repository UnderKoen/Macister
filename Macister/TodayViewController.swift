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
    @IBOutlet weak var gradeItems: NSScrollView!
    @IBOutlet weak var dayLabel: NSTextField!
    @IBOutlet weak var monthLabel: NSTextField!
    
    @IBInspectable var lessonHeight:Int = 48
    
    var calanderDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCalander()
        updateGrades()
    }
    
    @IBAction func nextDay(_ sender: Any) {
        calanderDate.addTimeInterval(86400)
        updateCalander()
    }
    
    @IBAction func previousDay(_ sender: Any) {
        calanderDate.addTimeInterval(-86400)
        updateCalander()
    }
    
    override func update() {
        updateCalander()
        updateGrades()
    }
    
    func updateCalander() {
        Magister.magister?.getLessonHandler()?.getLessonsForDay(day: calanderDate, completionHandler: { (lessons) in
            self.calanderItems.documentView!.subviews.removeAll()
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
        dayLabel.stringValue = DateUtil.getDateFormatTodayDay().string(from: calanderDate)
        monthLabel.stringValue = DateUtil.getDateFormatTodayMonth().string(from: calanderDate)
    }
    
    func updateGrades() {
        Magister.magister?.getGradeHandler()?.getLastGrades(completionHandler: { (grades) in
            if (grades != nil) {
                self.gradeItems.documentView!.subviews.removeAll()
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
                    self.gradeItems.documentView!.addSubview(el)
                })
                self.gradeItems.documentView!.scroll(NSPoint.init(x: 0, y: grades!.grades!.count*self.lessonHeight))
            } else {
                
            }
        })
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
