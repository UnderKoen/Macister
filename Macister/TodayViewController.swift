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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calanderItems.documentView!.scroll(NSPoint.init(x: 0, y: calanderItems.frame.height))
        let el = LessonElement.init(frame: CGRect.init(x: 0, y: 516, width: 252, height: 48))
        calanderItems.documentView!.addSubview(el)
        
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
