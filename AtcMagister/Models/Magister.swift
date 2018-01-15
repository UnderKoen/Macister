//
//  Magister.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class Magister: NSObject {
    static var magister:Magister? = nil
    
    var school:School
    var schoolUrl:SchoolUrl
    
    init(school: School) {
        self.school = school
        self.schoolUrl = SchoolUrl(school: self.school)
        super.init()
    }
    
    func getSchoolUrl() -> SchoolUrl {
        return schoolUrl
    }
    
    var cookies:String = ""
    
    func setCookies(cookies: String) {
        self.cookies = cookies
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
                        onSucces()
                    } else {
                        onError(msg.string!)
                    }
                } catch {}
            })
        }
    }
}
