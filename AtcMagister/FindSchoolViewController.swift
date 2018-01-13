//
//  FindSchoolViewController.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class FindSchoolViewController: NSViewController, NSComboBoxDelegate {

    @IBOutlet weak var FindSchool: NSComboBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FindSchool.delegate = self
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        FindSchool.removeAllItems()
        Alamofire.request("https://mijn.magister.net/api/schools", method: .get, parameters: ["filter": FindSchool.stringValue]).responseJSON { (response) in
            let data = response.data
            do {
                let json = try JSON(data: data!)
                json.array?.forEach({ (json) in
                    self.FindSchool.addItem(withObjectValue: json["Name"].string ?? "")
                })
            } catch {}
        }
    }
    
    @IBOutlet weak var error: NSTextField!
    
    @IBAction func `continue`(_ sender: Any) {
        let assigned = FindSchool.indexOfSelectedItem
        if assigned == -1 {
            error.stringValue = "Selecteer een school."
        } else {
            AppDelegate.changeView(controller: LoginViewController.freshController())
            Alamofire.request("https://mijn.magister.net/api/schools", method: .get, parameters: ["filter": FindSchool.stringValue]).responseJSON { (response) in
                let data = response.data
                do {
                    let json = try JSON(data: data!)
                    let schoolJson = json.array?.first
                    let school = School(url: schoolJson!["Url"].string ?? "", name: schoolJson!["Name"].string ?? "", id: schoolJson!["Id"].string ?? "")
                    Magister.magister = Magister(school: school)
                } catch {}
            }
        }
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
