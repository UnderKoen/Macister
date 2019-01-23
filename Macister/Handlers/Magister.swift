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
    static var maxWait: Double = 60.0
    static var magister: Magister?

    private var school: School
    private var mainUrl: MainUrl
    private var person: Person?
    private var account: Account?
    private var studies: Studies?
    private var grades: Grades?
    private var lessonHandler: LessonHandler?
    private var mailHandler: MailHandler?
    private var gradeHandler: GradeHandler?

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

    func getLessonHandler() -> LessonHandler? {
        return lessonHandler
    }

    func getMailHandler() -> MailHandler? {
        return mailHandler
    }

    func getGradeHandler() -> GradeHandler? {
        return gradeHandler
    }

    func logout() -> Future<NSNull> {
        loggedIn = false
        AssetHandler.getAsset(name: ".secrets.json").remove();
        return HttpUtil.httpDelete(url: mainUrl.schoolUrl!.getCurrentSessionUrl())
            .peek { _ in
                self.reset()
            }
            .done()
    }
    
    func reset() {
        HttpUtil.auth = ""
        Alamofire.SessionManager.default.session.configuration.httpCookieStorage!.removeCookies(since: Date.distantPast)
    }

    private var accountId: Int?
    private var loggedIn = false

    private var sessionId: String!
    private var returnUrl: String!
    private var xsrfToken: String!
    private var authCode: String!
    
    func login(username: String, password: String) -> Future<NSNull> {
        loggedIn = true
        return HttpUtil.httpGet(url: "https://accounts.magister.net/connect/authorize", parameters: ["client_id":mainUrl.schoolUrl!.getClientId(), "redirect_uri":mainUrl.schoolUrl!.getRedirectUri(), "response_type":"id_token token", "scope":"openid profile magister.ecs.legacy magister.mdv.broker.read magister.dnn.roles.read", "nonce":"\(arc4random())"])
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response in
                return response.response!.allHeaderFields["Location"]! as! String
            }
            .flatMap { url in
                return HttpUtil.httpGet(url: url)
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response in
                return response.response!.allHeaderFields["Location"]! as! String
            }
            .peek { url in
                self.sessionId = HttpUtil.getParameter(parameter: "sessionId", url: url)
                self.returnUrl = HttpUtil.getParameter(parameter: "returnUrl", url: url).removingPercentEncoding!
                for cookie in HTTPCookieStorage.shared.cookies! {
                    if cookie.name == "XSRF-TOKEN" { self.xsrfToken = cookie.value }
                }
            }
            .flatMap { url in
                return HttpUtil.httpGet(url: url)
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .flatMap { _ in
                return HttpUtil.httpGet(url: "https://macister.nl/authcode.php")
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response throws in
                return try JSON(data: response.data!)
            }
            .peek { json in
                self.authCode = json["authCode"].stringValue
            }
            .flatMap { _ in
                return HttpUtil.httpPost(url: "https://accounts.magister.net/challenge/current", parameters: ["sessionId":self.sessionId, "returnUrl":self.returnUrl, "authCode":self.authCode], headers: ["X-XSRF-TOKEN":self.xsrfToken])
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response throws in
                return try JSON(data: response.data!)
            }
            .check { json in
                let error = json["error"]
                if error != JSON.null { return error.stringValue }
                return nil
            }
            .flatMap { _ in
                return HttpUtil.httpPost(url: "https://accounts.magister.net/challenge/username", parameters: ["sessionId":self.sessionId, "returnUrl":self.returnUrl, "authCode":self.authCode,"username":username], headers: ["X-XSRF-TOKEN":self.xsrfToken])
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response throws in
                return try JSON(data: response.data!)
            }
            .check { json in
                let error = json["error"]
                if error != JSON.null { return error.stringValue }
                return nil
            }
            .flatMap { _ in
                return HttpUtil.httpPost(url: "https://accounts.magister.net/challenge/password", parameters: ["sessionId":self.sessionId, "returnUrl":self.returnUrl, "authCode":self.authCode,"password":password], headers: ["X-XSRF-TOKEN":self.xsrfToken])
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response throws in
                return try JSON(data: response.data!)
            }
            .check { json in
                let error = json["error"]
                if error != JSON.null { return error.stringValue }
                return nil
            }
            .flatMap { _ in
                return HttpUtil.httpGet(url: "https://accounts.magister.net" + self.returnUrl)
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response in
                return HttpUtil.getParameter(parameter: "access_token", url: response.response!.allHeaderFields["Location"]! as! String)
            }
            .peek { token in
                HttpUtil.auth = token
            }
            .flatMap { _ in
                return HttpUtil.httpPost(url: "https://macister.nl/activated.php", parameters: ["school":self.school.id,"user":username])
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response throws in
                return try JSON(data: response.data!)
            }
            .check { json in
                let activated = json["activated"].bool
                if (activated == nil) {
                    return json["error"].stringValue
                } else if !activated! {
                    return json["message"].stringValue
                }
                return nil
            }
            .flatMap { _ in
                return HttpUtil.httpGet(url: self.mainUrl.schoolUrl!.getCurrentSessionUrl())
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .map { response throws in
                return try JSON(data: response.data!)
            }
            .flatMap { json -> Future<NSNull> in
                let msg = json["message"]
                if msg == JSON.null {
                    self.accountId = Int((json["links"]["account"]["href"].string?.replacingOccurrences(of: "/api/accounts/", with: ""))!)
                    return self.initMagister()
                } else {
                    return Future(result: .failure(msg.string!))
                }
            }
            .check{ response in
                return response.error?.localizedDescription
            }
            .peek { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 60){//2700) {
                    if (self.loggedIn) {
                        self.logout().flatMap{_ in
                            return self.login(username: username, password: password)
                        }.execute()
                    }
                }
            }
            .onFailure{ error in
                print(error)
                self.reset()
            }
            .done()
    }

    private func initMagister() -> Future<NSNull> {
        return HttpUtil.httpGet(url: mainUrl.schoolUrl!.getUserUrl())
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .peek { json in
                    self.person = Person(json: json["Persoon"])
                }
                .flatMap({ _ in
                    return self.person!.loadImage()
                })
                .flatMap { _ in
                    return HttpUtil.httpGet(url: self.mainUrl.schoolUrl!.getAccountUrl(accountId: self.accountId!))
                }
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .peek { json in
                    self.account = Account(json: json)
                }
                .flatMap { _ in
                    return HttpUtil.httpGet(url: self.mainUrl.personUrl!.getStudiesUrl())
                }
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .peek { json in
                    self.studies = Studies(json: json)
                    
                    self.lessonHandler = LessonHandler(magister: self)
                    self.mailHandler = MailHandler(magister: self)
                    self.gradeHandler = GradeHandler(magister: self)
                }
                .done()
    }
}
