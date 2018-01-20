//
//  LoginViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 12/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

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
    
    private var timesWrong:[String:Int] = [:]
    private var busy:Bool = false
    @IBAction func Buttonaction(_ sender: Any) {
        if (!busy) {
            self.busy = true
            if self.isBlocked(user: self.UsernameTextField.stringValue) {
                self.error.stringValue = "Het account is 10 minuten geblokkeerd wegens overschrijding van het maximale aantal foutieve inlogpogingen."
                busy = false
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
                            self.progressBar.increment(by: 0.1)
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
                            self.timesWrong[self.UsernameTextField.stringValue] = (self.timesWrong[self.UsernameTextField.stringValue] ?? 0) + 1
                            if (self.timesWrong[self.UsernameTextField.stringValue] ?? 0) == 5 {
                                self.error.stringValue = "Het account is 10 minuten geblokkeerd wegens overschrijding van het maximale aantal foutieve inlogpogingen."
                                self.setBlock(user: self.UsernameTextField.stringValue, timeInMinutes: 10)
                                self.timesWrong[self.UsernameTextField.stringValue] = 0
                            }
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
    
    func isBlocked(user:String) -> Bool {
        var url:URL = FileUtil.getApplicationFolder()
        var json:JSON?
        url.appendPathComponent("blocked.json")
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            json = JSON.init(parseJSON: text)
        } catch {
            json = JSON.init(parseJSON: "{}")
        }
        return json!.contains(where: {(strS, jsonS) in
            if (strS == Magister.magister!.getSchool().name) {
                return jsonS.contains(where: { (strF, jsonF) -> Bool in
                    if (strF == self.UsernameTextField.stringValue) {
                        let date = DateUtil.getDateFromMagisterString(date: jsonF.stringValue)
                        if (date.timeIntervalSinceNow >= 0) {
                            return true
                        }
                    }
                    return false
                })
            }
            return false
        })
    }
    
    func setBlock(user:String, timeInMinutes:Int) {
        var url:URL = FileUtil.getApplicationFolder()
        var json:JSON?
        url.appendPathComponent("blocked.json")
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            if (text == "") {
                json = JSON(parseJSON: "{}")
            } else {
                json = JSON(parseJSON: text)
            }
        } catch {
            json = JSON(parseJSON: "{}")
        }
        var jsonS = json![Magister.magister!.getSchool().name]
        if (jsonS == JSON.null) {
            jsonS = JSON(parseJSON: "{}")
        }
        let until = Date.init(timeIntervalSinceNow: Double.init(timeInMinutes)*60.0)
        jsonS[user] = JSON.init(DateUtil.getDateFormatMagister().string(from: until))
        json![Magister.magister!.getSchool().name] = jsonS
        do {
            try json!.rawString()!.write(to: url, atomically: false, encoding: .utf8)
        }
        catch {}
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
