//
// Created by Koen van Staveren on 17/01/2018.
// Copyright (c) 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class PersonUrl: NSObject {
    var person:Person
    var schoolUrl:SchoolUrl

    init(person:Person, schoolUrl:SchoolUrl) {
        self.person = person
        self.schoolUrl = schoolUrl
    }

    func getPersonUrl() -> String {
        return schoolUrl.getApiUrl() + "personen/\((person.id!))/"
    }

    func getStudiesUrl() -> String {
        return getPersonUrl() + "aanmeldingen/"
    }

    func getPhotoUrl() -> String {
        return getPersonUrl() + "foto/"
    }
}
