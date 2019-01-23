//
//  CijferViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 30/11/2018.
//  Copyright © 2018 Under_Koen. All rights reserved.
//

import Cocoa

class CijferViewController: MainViewController {
    
    override func update() {
    }

}

extension CijferViewController {
    static func freshController() -> CijferViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Macister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "CijferViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CijferViewController else {
            fatalError("Why cant i find CijferViewController?")
        }
        return viewcontroller
    }
}
