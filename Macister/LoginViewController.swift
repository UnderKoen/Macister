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
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.minValue = 0
        progressBar.maxValue = Magister.maxWait
    }
    
    private var timesWrong:Int = 0
    private var busy:Bool = false
    @IBAction func Buttonaction(_ sender: Any) {
        if (!busy) {
            self.busy = true
            if timesWrong == 3 {
                self.error.stringValue = "Je hebt je wachtwoord al \(timesWrong) keer fout gedaan bij 5 word je account geblokkeerd."
                DispatchQueue.global().async {
                    usleep(useconds_t.init(1000000 * 5))
                    self.busy = false
                    self.timesWrong = 10
                }
            } else if (UsernameTextField.stringValue == "") || (PasswordTextField.stringValue == "") {
                error.stringValue = "Niet alles is ingevuld"
                busy = false
            } else {
                self.error.stringValue = ""
                self.progressBar.isHidden = false
                self.progressBar.startAnimation(self)
                DispatchQueue.global().async {
                    while self.busy {
                        usleep(useconds_t.init(1000000 * 0.1))
                        DispatchQueue.main.async {
                            self.progressBar.doubleValue = Magister.magister!.waiting
                        }
                    }
                    DispatchQueue.main.async {
                        self.progressBar.isHidden = true
                        self.progressBar.stopAnimation(self)
                    }
                }
                Magister.magister?.login(username: UsernameTextField.stringValue, password: PasswordTextField.stringValue, onError: { (error) in
                    DispatchQueue.main.async {
                        if (error.contains("Ongeldig account of verkeerde combinatie van gebruikersnaam en wachtwoord.")) {
                            self.error.stringValue = "Ongeldig account of verkeerde combinatie van gebruikersnaam en wachtwoord."
                            self.timesWrong = self.timesWrong+1
                        } else {
                            self.error.stringValue = error
                        }
                    }
                    self.busy = false
                }, onSucces: {
                    AppDelegate.changeView(controller: TodayViewController.freshController())
                    self.busy = false
                })
            }
        }
    }
    
}

extension LoginViewController {
    static func freshController() -> LoginViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Macister"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "LoginViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? LoginViewController else {
            fatalError("Why cant i find LoginViewController?")
        }
        return viewcontroller
    }
}
