//
//  FindSchoolViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class FindSchoolViewController: NSViewController, NSComboBoxDelegate {

    @IBOutlet weak var findSchool: CUComboBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findSchool.controlTextDidChange = {(obj) in
            School.findSchools(filter: self.findSchool.input.stringValue) { (schools) in
                self.findSchool.removeAll()
                self.findSchool.addItems(item: schools)
            }
        }
    }
    
    @IBOutlet weak var error: NSTextField!
    
    @IBAction func `continue`(_ sender: Any) {
        let assigned = findSchool.selectedItem
        if assigned == -1 {
            error.stringValue = "Selecteer een school."
        } else {
            AppDelegate.changeView(controller: LoginViewController.freshController())
            Magister.magister = Magister(school: findSchool.items[assigned] as! School)
        }
    }
}

extension FindSchoolViewController {
    static func freshController() -> FindSchoolViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Macister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "FindSchoolViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? FindSchoolViewController else {
            fatalError("Why cant i find FindSchoolViewController?")
        }
        return viewcontroller
    }
}
