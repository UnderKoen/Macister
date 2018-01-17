//
// Created by Koen van Staveren on 17/01/2018.
// Copyright (c) 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Account: NSObject {
    var done:Bool = false
    
    var id:Int?
    var naam:String?
    var emailadres:String?
    var mobielTelefoonnummer:String?
    var softtokenStatus:String?
    var isEmailadresGeverifieerd:Bool?
    var moetEmailadresVerifieren:Bool?
    var uuId:String?
    
    init(id:Int?, naam:String?, emailadres:String?, mobielTelefoonnummer:String?, softtokenStatus:String?, isEmailadresGeverifieerd:Bool?, moetEmailadresVerifieren:Bool?, uuId:String?) {
        self.id = id
        self.naam = naam
        self.emailadres = emailadres
        self.mobielTelefoonnummer = mobielTelefoonnummer
        self.softtokenStatus = softtokenStatus
        self.isEmailadresGeverifieerd = isEmailadresGeverifieerd
        self.moetEmailadresVerifieren = moetEmailadresVerifieren
        self.uuId = uuId
    }
    
    convenience init(json: JSON?) {
        self.init(id: json?["id"].int, naam: json?["naam"].string, emailadres: json?["emailadres"].string, mobielTelefoonnummer: json?["mobielTelefoonnummer"].string, softtokenStatus: json?["softtokenStatus"].string, isEmailadresGeverifieerd: json?["isEmailadresGeverifieerd"].bool, moetEmailadresVerifieren: json?["moetEmailadresVerifieren"].bool, uuId: json?["uuId"].string)
    }
}
