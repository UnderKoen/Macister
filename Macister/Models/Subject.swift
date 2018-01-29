//
//  Subject.swift
//  Macister
//
//  Created by Koen van Staveren on 25/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Subject: NSObject {
    var id:Int?
    var naam:String?
    
    init(id:Int?, naam:String?) {
        self.id = id
        self.naam = naam
    }
    
    convenience init(json:JSON?) {
        self.init(id: json?["Id"].int, naam: json?["Naam"].string)
    }
}
