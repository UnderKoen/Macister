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

    @IBOutlet weak var usernameTextField: CUTextField!
    @IBOutlet weak var passwordTextField: CUTextField!
    @IBOutlet weak var error: NSTextField!
    @IBOutlet weak var loading: NSProgressIndicator!
    @IBOutlet weak var remember: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private var timesWrong: [String: Int] = [:]
    private var busy: Bool = false {
        didSet {
            if (self.busy) {
                self.loading.isHidden = false
                self.loading.startAnimation(self)
                self.time += 1
                let t = self.time
                DispatchQueue.global().asyncAfter(deadline: .now() + 5, execute: {
                    if self.busy && self.time == t {
                        DispatchQueue.main.async {
                            self.busy = false
                            self.error.stringValue = "Het laden van de gegevens duurde telang."
                        }
                    }
                })
            } else {
                self.loading.isHidden = true
                self.loading.stopAnimation(self)
            }
        }
    }
    
    private var time = 0

    @IBAction func Buttonaction(_ sender: Any) {
        if (!busy) {
            self.busy = true
            let t = time
            if self.isBlocked(user: self.usernameTextField.input.stringValue) {
                self.error.stringValue = "Het account is 10 minuten geblokkeerd."
                busy = false
            } else if (usernameTextField.input.stringValue == "") || (passwordTextField.input.stringValue == "") {
                error.stringValue = "Niet alles is ingevuld"
                busy = false
            } else {
                self.error.stringValue = ""
                Magister.magister?.login(username: usernameTextField.input.stringValue, password: passwordTextField.input.stringValue).subscribe(onNext: { _ in
                    if !self.busy || self.time != t {
                        return
                    }
                    AppDelegate.changeView(controller: MainViewController.vandaagView)
                    self.busy = false
                    if (self.remember.state == .on) {
                        do {
                            var schoolJson = JSON(parseJSON: "{}")
                            schoolJson["name"] = JSON(rawValue: Magister.magister!.getSchool().name)!
                            schoolJson["id"] = JSON(rawValue: Magister.magister!.getSchool().id)!
                            schoolJson["url"] = JSON(rawValue: Magister.magister!.getSchool().url)!
                            var json = JSON(parseJSON: "{}")
                            json["school"] = schoolJson
                            json["user"] = JSON(rawValue: self.usernameTextField.input.stringValue)!
                            try json["pass"] = JSON(rawValue: EncryptionUtil.encryptMessage(message: self.passwordTextField.input.stringValue, encryptionKey: schoolJson["id"].stringValue))!
                            try AssetHandler.createAsset(name: ".secrets.json").setData(data: json.rawData());
                        } catch {
                        }
                    }
                }, onError: { error in
                    if (error.contains("Ongeldig account of verkeerde combinatie van gebruikersnaam en wachtwoord.")) {
                        self.error.stringValue = "Ongeldig account of verkeerde combinatie van gebruikersnaam en wachtwoord."
                        self.timesWrong[self.usernameTextField.input.stringValue] = (self.timesWrong[self.usernameTextField.input.stringValue] ?? 0) + 1
                        if (self.timesWrong[self.usernameTextField.input.stringValue] ?? 0) == 5 {
                            self.error.stringValue = "Het account is 10 minuten geblokkeerd."
                            self.setBlock(user: self.usernameTextField.input.stringValue, timeInMinutes: 10)
                            self.timesWrong[self.usernameTextField.input.stringValue] = 0
                        }
                    } else {
                        self.error.stringValue = error
                    }
                    let school = Magister.magister?.getSchool()
                    Magister.magister = Magister(school: school!)
                    self.busy = false
                })
            }
        }
    }

    @IBAction func goBack(_ sender: Any) {
        AppDelegate.changeView(controller: FindSchoolViewController.freshController())
        Magister.magister = nil
    }

    func isBlocked(user: String) -> Bool {
        var url: URL = FileUtil.getApplicationFolder()
        var json: JSON?
        url.appendPathComponent(".blocked.json")
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            json = JSON.init(parseJSON: text)
        } catch {
            json = JSON.init(parseJSON: "{}")
        }
        return json!.contains(where: { (strS, jsonS) in
            if (strS == Magister.magister!.getSchool().name) {
                return jsonS.contains(where: { (strF, jsonF) -> Bool in
                    if (strF == self.usernameTextField.input.stringValue) {
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

    func setBlock(user: String, timeInMinutes: Int) {
        var url: URL = FileUtil.getApplicationFolder()
        var json: JSON?
        url.appendPathComponent(".blocked.json")
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
        let until = Date.init(timeIntervalSinceNow: Double.init(timeInMinutes) * 60.0)
        jsonS[user] = JSON.init(DateUtil.getDateFormatMagister().string(from: until))
        json![Magister.magister!.getSchool().name] = jsonS
        do {
            try json!.rawString()!.write(to: url, atomically: false, encoding: .utf8)
        } catch {
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
