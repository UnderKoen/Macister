//
//  FindSchoolViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class FindSchoolViewController: NSViewController, NSComboBoxDelegate {

    @IBOutlet weak var FindSchool: NSComboBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FindSchool.delegate = self
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        FindSchool.removeAllItems()
        School.findSchools(filter: FindSchool.stringValue) { (schools) in
            schools.forEach({ (school) in
                self.FindSchool.addItem(withObjectValue: school.name)
            })
        }
    }
    
    @IBOutlet weak var error: NSTextField!
    
    @IBAction func `continue`(_ sender: Any) {
        let assigned = FindSchool.indexOfSelectedItem
        if assigned == -1 {
            error.stringValue = "Selecteer een school."
        } else {
            AppDelegate.changeView(controller: LoginViewController.freshController())
            School.findSchools(filter: FindSchool.stringValue, completionHandler: { (schools) in
                Magister.magister = Magister(school: schools.first!)
            })
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
