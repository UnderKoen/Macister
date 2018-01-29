//
//  Teacher.swift
//  Macister
//
//  Created by Koen van Staveren on 25/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Teacher: NSObject {
    var id:Int?
    var naam:String?
    var docentcode:String?
    
    init(id:Int?, naam:String?, docentcode:String?) {
        self.id = id
        self.naam = naam
        self.docentcode = docentcode
    }
    
    convenience init(json: JSON?) {
        self.init(id: json?["Id"].int, naam: json?["Naam"].string, docentcode: json?["Docentcode"].string)
    }
}
