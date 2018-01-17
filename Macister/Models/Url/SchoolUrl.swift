//
//  SchoolUrl.swift
//  Macister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class SchoolUrl: NSObject {
    var school:School
    var accountId:Int?
    
    init(school:School) {
        self.school = school
    }
    
    func getMagisterUrl() -> String {
        return school.url + "/"
    }
    
    func getApiUrl() -> String {
        return getMagisterUrl() + "api/"
    }
    
    func getVersionUrl() -> String {
        return getApiUrl() + "versie/"
    }
    
    func getSessionUrl() -> String {
        return getApiUrl() + "sessies/"
    }
    
    func getCurrentSessionUrl() -> String {
        return getSessionUrl() + "huidige/"
    }
    
    func getUserUrl() -> String {
        return getApiUrl() + "account/"
    }
    
    //-------------------------==  ACCOUNT  ==-------------------------//
    
    func setAccountId(accountId:Int) {
        self.accountId = accountId
    }
    
    func getAccountUrl() -> String {
        return getApiUrl() + "accounts/\(accountId!)"
    }
}
