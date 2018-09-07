//
//  ClassRoom.swift
//  Macister
//
//  Created by Koen van Staveren on 25/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ClassRoom: NSObject {
    var naam: String?

    init(naam: String?) {
        self.naam = naam
    }

    convenience init(json: JSON?) {
        self.init(naam: json?["Naam"].string)
    }
}
