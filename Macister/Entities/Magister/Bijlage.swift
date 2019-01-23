//
//  Bijlage.swift
//  Macister
//
//  Created by Koen van Staveren on 16/11/2018.
//  Copyright © 2018 Under_Koen. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Bijlage: NSObject {
    var json: JSON!

    var id: Int?
    var naam: String?
    var contentType: String?
    var status: Int?
    var datum: String?
    var datumDate: Date?
    var grootte: Int?
    var bronSoort: Int?

    init(json: JSON!, id: Int?, naam: String?, contentType: String?, status: Int?, datum: String?, grootte: Int?, bronSoort: Int?) {
        self.json = json

        self.id = id
        self.naam = naam
        self.contentType = contentType
        self.status = status
        self.datum = datum
        if (datum != nil) {
            self.datumDate = DateUtil.getDateFromMagisterString(date: datum!)
        }
        self.grootte = grootte
        self.bronSoort = bronSoort
    }

    convenience init(json: JSON?) {
        self.init(json: json, id: json?["Id"].int, naam: json?["Naam"].string, contentType: json?["ContenType"].string, status: json?["Status"].int, datum: json?["Datum"].string, grootte: json?["Grootte"].int, bronSoort: json?["BronSoort"].int)
    }
}

