//
//  MainViewController.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var berichten: NSView!
    @IBOutlet weak var cijfers: NSView!
    @IBOutlet weak var agenda: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Magister.magister?.getProfile()?.getName())
    }
    
    @IBAction func switchTo(_ sender: Any) {
        if let tab = sender as? NSClickGestureRecognizer {
            let view = tab.view
            if view == berichten {
                print("berichten")
            } else if view == cijfers {
                print("cijfers")
            } else if view == agenda {
                //print(Magister.magister?.getProfile()?.getName())
            }
        }
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
