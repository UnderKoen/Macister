//
//  Profile.swift
//  Macister
//
//  Created by Koen van Staveren on 15/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Person: NSObject {
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
    var profielFoto:NSImage?
    
    func getName() -> String {
        if (tussenvoegsel == nil) {
            return "\(roepNaam ?? "") \(achternaam ?? "")"
        } else {
            return "\(roepNaam ?? "") \(tussenvoegsel ?? "") \(achternaam ?? "")"
        }
    }
    
    func getOfficialName() -> String {
        if gebruikGeboortenaam! {
            if (geboortenaamTussenvoegsel == nil) {
                return "\(officieleVoornamen ?? "") \(geboorteAchternaam ?? "")"
            } else {
                return "\(officieleVoornamen ?? "") \(geboortenaamTussenvoegsel ?? "") \(geboorteAchternaam ?? "")"
            }
        } else {
            if (officieleTussenvoegsels == nil) {
                return "\(officieleVoornamen ?? "") \(officieleAchternaam ?? "")"
            } else {
                return "\(officieleVoornamen ?? "") \(officieleTussenvoegsels ?? "") \(officieleAchternaam ?? "")"
            }
        }
    }
    
    init(id:Int?, roepNaam:String?, tussenvoegsel:String?, achternaam:String?, officieleVoornamen:String?, voorletters:String?, officieleTussenvoegsels:String?,  officieleAchternaam:String?, geboortedatum:String?, geboorteAchternaam:String?, geboortenaamTussenvoegsel:String?, gebruikGeboortenaam:Bool?, profielFoto:NSImage?) {
        self.id = id
        Magister.magister!.getSchoolUrl().setProfileId(profileId: id!)
        self.roepNaam = roepNaam
        self.tussenvoegsel = tussenvoegsel
        self.achternaam = achternaam
        self.officieleVoornamen = officieleVoornamen
        self.voorletters = voorletters
        self.officieleTussenvoegsels = officieleTussenvoegsels
        self.officieleAchternaam = officieleAchternaam
        self.geboortedatum = geboortedatum
        self.geboorteAchternaam = geboorteAchternaam
        self.geboortenaamTussenvoegsel = geboortenaamTussenvoegsel
        self.gebruikGeboortenaam = gebruikGeboortenaam
        self.profielFoto = profielFoto
    }
    
    convenience init(json:JSON?) {
        self.init(id: json?["Id"].int, roepNaam: json?["Roepnaam"].string, tussenvoegsel: json?["Tussenvoegsel"].string, achternaam: json?["Achternaam"].string, officieleVoornamen: json?["OfficieleVoornamen"].string, voorletters: json?["Voorletters"].string, officieleTussenvoegsels: json?["OfficieleTussenvoegsels"].string, officieleAchternaam: json?["OfficieleAchternaam"].string, geboortedatum: json?["Geboortedatum"].string, geboorteAchternaam: json?["GeboorteAchternaam"].string, geboortenaamTussenvoegsel: json?["GeboortenaamTussenvoegsel"].string, gebruikGeboortenaam: json?["GebruikGeboortenaam"].bool, profielFoto: nil)
        HttpUtil.httpGetFile(url: Magister.magister!.getSchoolUrl().getPhotoUrl(), fileName: "pf.png") { (response) in
            if let data = response.result.value {
                self.profielFoto = NSImage(data: data)
                self.done = true
            }
        }
    }
}
