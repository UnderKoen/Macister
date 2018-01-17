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
    private var schoolUrl:SchoolUrl
    private var person:Person?
    private var studies:Studies?
    
    init(school: School) {
        self.school = school
        self.schoolUrl = SchoolUrl(school: self.school)
    }
    
    func getSchoolUrl() -> SchoolUrl {
        return schoolUrl
    }
    
    func getPerson() -> Person? {
        return person
    }
    
    func getStudies() -> Studies? {
        return studies
    }
    
    func logout() {
        HttpUtil.httpDelete(url: schoolUrl.getCurrentSessionUrl())
    }
    
    func login(username: String, password: String, onError: @escaping (_ error: String) -> Void, onSucces: @escaping () -> Void) {
        logout()
        DispatchQueue.global().async {
            while(HttpUtil.cookies == "") {
                usleep(useconds_t.init(1000000 * 0.1))
            }
            HttpUtil.httpPost(url: self.schoolUrl.getSessionUrl(), parameters: ["Gebruikersnaam":username,"Wachtwoord":password,"IngelogdBlijven":true], completionHandler: { (response) in
                do {
                    let json = try JSON(data: response.data!)
                    let msg = json["message"]
                    if msg == JSON.null {
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
        HttpUtil.httpGet(url: schoolUrl.getUserUrl()) { (response) in
            do {
                let json = try JSON(data: response.data!)
                let person = json["Persoon"]
                self.person = Person(json: person)
            } catch {}
        }
        DispatchQueue.global().async {
            while !((self.person?.done ?? false)) {
                usleep(useconds_t.init(1000000 * 0.1))
                if self.waiting > Magister.maxWait {
                    return
                }
            }
            HttpUtil.httpGet(url: self.schoolUrl.getStudiesUrl()) { (response) in
                do {
                    let json = try JSON(data: response.data!)
                    self.studies = Studies.init(json: json)
                } catch {}
            }
        }
        DispatchQueue.global().async {
            while !((self.person?.done ?? false) && (self.studies?.done ?? false)) {
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
