//
//  Studies.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Grades: NSObject {
    var done:Bool = false
    
    var grades:[Grade]?
    var lastGrade:Grade?
    
    init(grades:[Grade]?, lastGrade:Grade?) {
        self.grades = grades
        self.lastGrade = lastGrade
    }
    
    convenience init (json: JSON?) {
        let items = json!["Items"].array
        var grades:[Grade] = []
        var lastGrade:Grade?
        items?.forEach({ (json) in
            let grade = Grade(json: json)
            grade.append(study)
            if study.eindeDate!.timeIntervalSinceNow > 0.0 {
                lastGrade = grade
            }
        })
        self.init(grades: grades, lastGrade: lastGrade)
        self.done = true
    }
}

