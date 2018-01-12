//
//  FindSchoolViewController.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import Alamofire

class FindSchoolViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func FindSchools(_ sender: Any) {
        AppDelegate.changeView(controller: LoginViewController.freshController())
    }
    
}

extension FindSchoolViewController {
    static func freshController() -> FindSchoolViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Magister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "FindSchoolViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? FindSchoolViewController else {
            fatalError("Why cant i find FindSchoolViewController?")
        }
        return viewcontroller
    }
}
