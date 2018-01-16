//
//  StudyInfo.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class StudyInfo: NSObject {
    var id:Int?
    var omschrijving:String?
    
    init(id:Int?, omschrijving:String?) {
        self.id = id
        self.omschrijving = omschrijving
        super.init()
    }
    
    convenience init(json:JSON?) {
        self.init(id: json?["Id"].int, omschrijving: json?["Omschrijving"].string)
    }
}
