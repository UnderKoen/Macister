//
//  SpecialViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 18/05/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class SpecialViewController: MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension SpecialViewController {
    static func freshController() -> SpecialViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Macister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "SpecialViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? SpecialViewController else {
            fatalError("Why cant i find SpecialViewController?")
        }
        return viewcontroller
    }
}

