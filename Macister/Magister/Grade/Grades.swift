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
    
    init(grades:[Grade]?) {
        self.grades = grades
    }
    
    convenience init (json: JSON?) {
        let items = json!["Items"].array
        var grades:[Grade] = []
        items?.forEach({ (json) in
            let grade = Grade(json: json)
            grades.append(grade)
        })
        self.init(grades: grades)
        self.done = true
    }
}

