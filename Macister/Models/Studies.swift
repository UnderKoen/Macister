//
//  Studies.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Studies: NSObject {
    var done:Bool = false
    
    var studies:[Study]?
    var currentStudy:Study?
    
    init(studies:[Study]?, currentStudy:Study?) {
        self.studies = studies
        self.currentStudy = currentStudy
    }
    
    convenience init (json: JSON?) {
        let items = json!["Items"].array
        var studies:[Study] = []
        var currentStudy:Study?
        items?.forEach({ (json) in
            let study = Study(json: json)
            studies.append(study)
            if study.eindeDate!.timeIntervalSinceNow > 0.0 {
                currentStudy = study
            }
        })
        self.init(studies: studies, currentStudy: currentStudy)
        self.done = true
    }
}
