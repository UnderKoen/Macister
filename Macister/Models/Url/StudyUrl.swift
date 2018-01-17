//
//  StudyUrl.swift
//  Macister
//
//  Created by Koen van Staveren on 17/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class StudyUrl: NSObject {
    var study:Study
    var personUrl:PersonUrl

    init(study:Study, personUrl:PersonUrl) {
        self.study = study
        self.personUrl = personUrl
    }
    
    func getStudyUrl() -> String  {
        return self.personUrl.getStudiesUrl() + "\(study.id!)"
    }
    
    func getRecentGrateUrl() -> String  {
        return getStudyUrl() + "cijfers/"
    }
    
    func getGratesUrl() -> String  {
        return getRecentGrateUrl() + "cijferoverzichtvooraanmelding/"
    }
}
