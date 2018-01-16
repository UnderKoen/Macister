//
//  LoginViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    @IBOutlet weak var UsernameTextField: NSTextField!
    @IBOutlet weak var PasswordTextField: NSSecureTextField!
    @IBOutlet weak var error: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Buttonaction(_ sender: Any) {
        if (UsernameTextField.stringValue == "") || (PasswordTextField.stringValue == "") {
            error.stringValue = "Niet alles is ingevuld"
        } else {
            Magister.magister?.login(username: UsernameTextField.stringValue, password: PasswordTextField.stringValue, onError: { (error) in
                self.error.stringValue = "Ongeldig account of verkeerde combinatie van gebruikersnaam en wachtwoord."
            }, onSucces: {
                AppDelegate.changeView(controller: MainViewController.freshController())
            })
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
