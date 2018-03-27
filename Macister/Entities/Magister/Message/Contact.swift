//
//  Contact.swift
//  Macister
//
//  Created by Koen van Staveren on 07/02/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Contact: NSObject {
    var id:Int?
    var achternaam:String?
    var voornaam:String?
    var tussenvoegsel:String?
    var naam:String?
    var type:ContactType?
    var code:String?
    
    init(id:Int?, achternaam:String?, voornaam:String?, tussenvoegsel:String?, naam:String?, type:ContactType?, code:String?) {
        self.id = id
        self.achternaam = achternaam
        self.voornaam = voornaam
        self.tussenvoegsel = tussenvoegsel
        self.naam = naam
        self.type = type
        self.code = code
    }
    
    convenience init(json:JSON?) {
        self.init(id: json?["Id"].int, achternaam: json?["Achternaam"].string, voornaam: json?["Voornaam"].string, tussenvoegsel: json?["Tussenvoegsel"].string, naam: json?["Naam"].string, type: ContactType(rawValue: json?["Type"].int ?? 0), code: json?["Code"].string)
    }
}
