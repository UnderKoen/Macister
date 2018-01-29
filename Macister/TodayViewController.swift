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
    @IBOutlet weak var dayLabel: NSTextField!
    
    @IBInspectable var lessonHeight:Int = 48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Magister.magister?.getLessonHandler()?.getLessons(from: Date(), until: Date(), completionHandler: { (lessons) in
            var y:Int = Int(self.calanderItems.frame.height)
            if y-(lessons.count*self.lessonHeight) < 0 {
                self.calanderItems.documentView!.setFrameSize(NSSize(width: self.calanderItems.contentSize.width, height: CGFloat(lessons.count*48)))
                y = lessons.count*self.lessonHeight
            }
            lessons.forEach({ (lesson) in
                y = y-self.lessonHeight
                let el = LessonElement(frame: CGRect(x: 0, y: y, width: 252, height: self.lessonHeight))
                el.lesson = lesson
                self.calanderItems.documentView!.addSubview(el)
            })
            self.calanderItems.documentView!.scroll(NSPoint.init(x: 0, y: lessons.count*self.lessonHeight))
        })
        dayLabel.stringValue = DateUtil.getDateFormatToday().string(from: Date())
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
