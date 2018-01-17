//
//  MainUrl.swift
//  Macister
//
//  Created by Koen van Staveren on 17/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class MainUrl: NSObject {
    var schoolUrl:SchoolUrl?
    var personUrl:PersonUrl?
    var studentUrl:StudentUrl?
    var accountUrl:AccountUrl?
    
    func setSchool(school:School) {
        self.schoolUrl = SchoolUrl.init(school: school)
    }
    
    func setPerson(person:Person) {
        self.personUrl = PersonUrl.init(person: person, schoolUrl: schoolUrl!)
        self.studentUrl = StudentUrl.init(person: person, schoolUrl: schoolUrl!)
    }
    
    func setAccount(account:Account) {
        self.accountUrl = AccountUrl.init(account: account, schoolUrl: schoolUrl!)
    }
}
