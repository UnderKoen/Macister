//
//  Studies.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class Studies: NSObject {
    var done:Bool = false
    
    var studies:[Study]?
    var currentStudy:Study?
    
    init(studies:[Study]?, currentStudy:Study?) {
        self.studies = studies
        self.currentStudy = currentStudy
    }
    
    //convenience init (json: JSON?) {
        
    //}
}
