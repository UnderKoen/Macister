//
//  LoginViewController.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftHTTP

class LoginViewController: NSViewController {

    @IBOutlet weak var UsernameTextField: NSTextField!
    @IBOutlet weak var PasswordTextField: NSSecureTextField!
    
    static var school: School = School(url: "", name: "", id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Buttonaction(_ sender: Any) {
        if (UsernameTextField.stringValue == "") || (PasswordTextField.stringValue == "") {
            print("empty")
        } else {
            HTTP.DELETE("https://domain.com/1") { response in
                
            }
        }
        
    }
    
}

extension LoginViewController {
    static func freshController() -> LoginViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Magister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "LoginViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? LoginViewController else {
            fatalError("Why cant i find LoginViewController?")
        }
        return viewcontroller
    }
}
