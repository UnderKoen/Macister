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
        Alamofire.request(schoolUrl.getCurrentSessionUrl(), method: .delete, encoding: JSONEncoding.default, headers: ["X-API-Client-ID":"12D8"]).responseJSON { (response) in
            self.setCookies(cookies: response.response?.allHeaderFields["Set-Cookie"] as! String)
        }
    }
    
    func login(username: String, password: String, onError: @escaping (_ error: String) -> Void, onSucces: @escaping () -> Void) {
        logout()
        DispatchQueue.global().async {
            Alamofire.request(self.schoolUrl.getSessionUrl(), method: .post, parameters: ["Gebruikersnaam":username,"Wachtwoord":password], encoding: JSONEncoding.default, headers: ["Cookie":self.cookies,"X-API-Client-ID":"12D8","Content-Type":"application/json"]).responseJSON { (response) in
                do {
                    let json = try JSON(data: response.data!)
                    let msg = json["message"]
                    if msg == JSON.null {
                        onSucces()
                    } else {
                        onError(msg.string!)
                    }
                } catch {}
            }
        }
    }
}
