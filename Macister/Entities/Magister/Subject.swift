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
    var id: Int?
    var naam: String?
    var afkorting: String?
    var volgnr: Int?

    init(id: Int?, naam: String?, afkorting: String?, volgnr: Int?) {
        self.id = id
        self.naam = naam
        self.afkorting = afkorting
        self.volgnr = volgnr
    }

    convenience init(json: JSON?) {
        self.init(id: json?["Id"].int, naam: json?["Naam"].string ?? json?["Omschrijving"].string ?? json?["omschrijving"].string, afkorting: json?["Afkorting"].string ?? json?["code"].string, volgnr: json?["Volgnr"].int)
    }
}
