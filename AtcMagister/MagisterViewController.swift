//
//  MagisterViewController.swift
//  UnderMagister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class MagisterViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension MagisterViewController {
    static func freshController() -> MagisterViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "MagisterViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MagisterViewController else {
            fatalError("Why cant i find MagisterViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
