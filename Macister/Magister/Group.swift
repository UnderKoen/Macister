//
//  Group.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Group: NSObject {
    var id:Int?
    var omschrijving:String?
    var locatieId:Int?
    
    init(id:Int?, omschrijving:String?, locatieId:Int?) {
        self.id = id
        self.omschrijving = omschrijving
        self.locatieId = locatieId
        super.init()
    }
    
    convenience init(json: JSON?) {
        self.init(id: json?["Id"].int, omschrijving: json?["Omschrijving"].string, locatieId: json?["LocatieId"].int)
    }
}
