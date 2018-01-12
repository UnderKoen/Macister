//
//  LoginViewController.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    @IBOutlet weak var UsernameTextField: NSTextField!
    @IBOutlet weak var PasswordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func Buttonaction(_ sender: Any) {
        if (UsernameTextField.stringValue == "") || (PasswordTextField.stringValue == "") {
            print("empty")
        } else {
            print("do the authentication stuff")
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
