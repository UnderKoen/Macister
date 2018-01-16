//
//  CalendarViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class CalendarViewController: MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
