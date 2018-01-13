//
//  FindSchoolViewController.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftHTTP
import SwiftyJSON

class FindSchoolViewController: NSViewController, NSComboBoxDelegate {

    @IBOutlet weak var FindSchool: NSComboBox!
    
    @IBAction func FindSchools(_ sender: Any) {
        print(FindSchool.indexOfSelectedItem)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FindSchool.delegate = self
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        FindSchool.removeAllItems()
        HTTP.GET("https://mijn.magister.net/api/schools", parameters: ["filter": FindSchool.stringValue], headers: [:], requestSerializer: JSONParameterSerializer()) { response in
            let data = response.data
            do {
                let json = try JSON(data: data)
                json.array?.forEach({ (json) in
                    self.FindSchool.addItem(withObjectValue: json["Name"].string ?? "")
                })
            } catch {}
        }
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        print("tets")
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
