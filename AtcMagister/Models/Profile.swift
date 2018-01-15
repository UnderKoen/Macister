//
//  Profile.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 15/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Profile: NSObject {
    var done:Bool = false
    
    var id:Int?
    var roepNaam:String?
    var tussenvoegsel:String?
    var achternaam:String?
    var officieleVoornamen:String?
    var voorletters:String?
    var officieleTussenvoegsels:String?
    var officieleAchternaam:String?
    var geboortedatum:String?
    var geboorteAchternaam:String?
    var geboortenaamTussenvoegsel:String?
    var gebruikGeboortenaam:Bool?
    
    func getName() -> String {
        return "\(roepNaam ?? "") \(tussenvoegsel ?? "") \(achternaam ?? "")"
    }
    
    func getOfficialName() -> String {
        if gebruikGeboortenaam! {
            return "\(officieleVoornamen ?? "") \(geboortenaamTussenvoegsel ?? "") \(geboorteAchternaam ?? "")"
        } else {
            return "\(officieleVoornamen ?? "") \(officieleTussenvoegsels ?? "") \(officieleAchternaam ?? "")"
        }
    }
    
    init(magister: Magister) {
        super.init()
        HttpUtil.httpGet(url: magister.getSchoolUrl().getUserUrl()) { (response) in
            do {
                let json = try JSON(data: response.data!)
                let person = json["Persoon"]
                self.id = person["Id"].int
                self.roepNaam = person["Roepnaam"].string
                self.tussenvoegsel = person["Tussenvoegsel"].string
                self.achternaam = person["Achternaam"].string
                self.officieleVoornamen = person["OfficieleVoornamen"].string
                self.voorletters = person["Voorletters"].string
                self.officieleTussenvoegsels = person["OfficieleTussenvoegsels"].string
                self.officieleAchternaam = person["OfficieleAchternaam"].string
                self.geboortedatum = person["Geboortedatum"].string
                self.geboorteAchternaam = person["GeboorteAchternaam"].string
                self.geboortenaamTussenvoegsel = person["GeboortenaamTussenvoegsel"].string
                self.gebruikGeboortenaam = person["GebruikGeboortenaam"].bool
            } catch {}
            self.done = true
        }
    }
}
