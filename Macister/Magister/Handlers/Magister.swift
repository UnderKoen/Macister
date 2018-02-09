//
//  Magister.swift
//  Macister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class Magister: NSObject {
    static var maxWait:Double = 60.0
    static var magister:Magister?
    
    private var school:School
    private var mainUrl:MainUrl
    private var person:Person?
    private var account:Account?
    private var studies:Studies?
    private var grades:Grades?
    private var lessonHandler:LessonHandler?
    private var gradeHandler:GradeHandler?
    
    init(school: School) {
        self.school = school
        self.mainUrl = MainUrl()
        self.mainUrl.setSchool(school: school)
    }
    
    func getSchool() -> School {
        return school
    }
    
    func getMainUrl() -> MainUrl {
        return mainUrl
    }
    
    func getPerson() -> Person? {
        return person
    }
    
    func getAccount() -> Account? {
        return account
    }
    
    func getStudies() -> Studies? {
        return studies
    }
    
    func getGrades() -> Grades? {
        return grades
    }
    
    func getLessonHandler () -> LessonHandler? {
        return lessonHandler
    }
    
    func getGradeHandler () -> GradeHandler? {
        return gradeHandler
    }
    
    func logout(forCookie:Bool = false) {
        HttpUtil.httpDelete(url: mainUrl.schoolUrl!.getCurrentSessionUrl())
        if (!forCookie) {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "nl.underkoen.Macister"] as [String : Any]
            SecItemDelete(query as CFDictionary)
        }
    }
    
    private var accountId:Int?
    
    func login(username: String, password: String, onError: @escaping (_ error: String) -> Void, onSucces: @escaping () -> Void) {
        logout(forCookie: true)
        DispatchQueue.global().async {
            while(HttpUtil.cookies == "") {
                usleep(useconds_t.init(1000000 * 0.1))
            }
            HttpUtil.httpPost(url: self.mainUrl.schoolUrl!.getSessionUrl(), parameters: ["Gebruikersnaam":username,"Wachtwoord":password,"IngelogdBlijven":true], completionHandler: { (response) in
                do {
                    let json = try JSON(data: response.data!)
                    let msg = json["message"]
                    if msg == JSON.null {
                        self.accountId = Int((json["links"]["account"]["href"].string?.replacingOccurrences(of: "/api/accounts/", with: ""))!)
                        self.init_magister(onSucces, onError)
                    } else {
                        onError(msg.string!)
                    }
                    return
                } catch {}
                onError("Iets ging mis probeer opnieuw")
            })
        }
    }
    
    var waiting = 0.0
    
    private func init_magister(_ whenDone: @escaping () -> Void, _ onError: @escaping (_ error: String) -> Void) {
        waiting = 0.0
        HttpUtil.httpGet(url: mainUrl.schoolUrl!.getUserUrl()) { (response) in
            do {
                let json = try JSON(data: response.data!)
                let person = json["Persoon"]
                self.person = Person(json: person)
            } catch {}
        }
        HttpUtil.httpGet(url: mainUrl.schoolUrl!.getAccountUrl(accountId: accountId!)) { (response) in
            do {
                let json = try JSON(data: response.data!)
                self.account = Account.init(json: json)
            } catch {}
        }
        DispatchQueue.global().async {
            while !((self.person?.done ?? false)) {
                usleep(useconds_t.init(1000000 * 0.1))
                if self.waiting > Magister.maxWait {
                    return
                }
            }
            self.lessonHandler = LessonHandler.init(magister: self)
            self.gradeHandler = GradeHandler.init(magister: self)
            HttpUtil.httpGet(url: self.mainUrl.personUrl!.getStudiesUrl()) { (response) in
                do {
                    let json = try JSON(data: response.data!)
                    self.studies = Studies.init(json: json)
                } catch {}
            }
        }
        DispatchQueue.global().async {
            while !((self.person?.done ?? false) && (self.studies?.done ?? false) && (self.account?.done ?? false)) {
                usleep(useconds_t.init(1000000 * 0.1))
                self.waiting = self.waiting + 0.1
                if self.waiting > Magister.maxWait {
                    onError("Het inloggen duurde te lang.")
                    return
                }
            }
            whenDone()
        }
    }
}
