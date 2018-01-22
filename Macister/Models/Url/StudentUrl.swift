//
// Created by Koen van Staveren on 17/01/2018.
// Copyright (c) 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class StudentUrl: NSObject {
    var person:Person
    var schoolUrl:SchoolUrl

    init(person:Person, schoolUrl:SchoolUrl) {
        self.person = person
        self.schoolUrl = schoolUrl
    }

    func getStudentUrl() -> String {
        return self.schoolUrl.getApiUrl() + "leerlingen/\(person.id!)/"
    }
}
