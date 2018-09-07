//
//  GradePeriod.swift
//  Macister
//
//  Created by Koen van Staveren on 29/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class GradePeriod: NSObject {
    var id: Int?
    var naam: String?
    var volgNummer: Int?

    init(id: Int?, naam: String?, volgNummer: Int?) {
        self.id = id
        self.naam = naam
        self.volgNummer = volgNummer
    }

    convenience init(json: JSON?) {
        self.init(id: json?["Id"].int, naam: json?["Naam"].string, volgNummer: json?["VolgNummer"].int)
    }
}
