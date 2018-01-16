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
    static var magister:Magister?
    
    private var school:School
    private var schoolUrl:SchoolUrl
    private var profile:Profile?
    
    init(school: School) {
        self.school = school
        self.schoolUrl = SchoolUrl(school: self.school)
    }
    
    func getSchoolUrl() -> SchoolUrl {
        return schoolUrl
    }
    
    func getProfile() -> Profile? {
        return profile
    }
    
    func logout() {
        HttpUtil.httpDelete(url: schoolUrl.getCurrentSessionUrl())
    }
    
    func login(username: String, password: String, onError: @escaping (_ error: String) -> Void, onSucces: @escaping () -> Void) {
        logout()
        DispatchQueue.global().async {
            while(HttpUtil.cookies == "") {
                sleep(UInt32(0.1))
            }
            HttpUtil.httpPost(url: self.schoolUrl.getSessionUrl(), parameters: ["Gebruikersnaam":username,"Wachtwoord":password,"IngelogdBlijven":true], completionHandler: { (response) in
                do {
                    let json = try JSON(data: response.data!)
                    let msg = json["message"]
                    if msg == JSON.null {
                        self.init_magister(onSucces)
                    } else {
                        onError(msg.string!)
                    }
                } catch {}
            })
        }
    }
    
    private func init_magister(_ whenDone: @escaping () -> Void) {
        profile = Profile.init(magister: self)
        DispatchQueue.global().async {
            while !self.profile!.done {
                sleep(UInt32(0.1))
            }
            whenDone()
        }
    }
}
