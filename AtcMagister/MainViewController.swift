//
//  MainViewController.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension MainViewController {
    static func freshController() -> MainViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Magister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "MainViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MainViewController else {
            fatalError("Why cant i find MainViewController?")
        }
        return viewcontroller
    }
}
