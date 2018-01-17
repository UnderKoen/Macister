//
//  Study.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Grade: NSObject {
    var done:Bool = false
    
    var id:Int?
    var CijferStr:String?
    var isVoldoende:Bool?
    var IngevoerdDoor:NSObject?
    var DatumIngevoerd:String?
    var CijferPeriode:Date?
    //var CijferPeriode:GradePeriod?
    //var Vak:Subject?
    var Inhalen:Bool?
    var Vrijstelling:Bool?
    var TeltMee:Bool?
    //var CijferKolom:GradeColomn;
    var CijferKolomIdEloOpdracht:Int?
    var Docent:String?
    var VakDispensatie:Bool?
    var VakVrijstelling:Bool?
    
    init(id:Int?, CijferStr:String?, isVoldoende:Bool?, IngevoerdDoor:NSObject?, lesperiode:String?, groep:Group?, studieInfo:StudyInfo?) {
        self.id = id
        self.leerlingId = leerlingId
        self.start = start
        self.startDate = DateUtil.getDateFromString(date: start!)
        self.einde = einde
        self.eindeDate = DateUtil.getDateFromString(date: einde!)
        self.lesperiode = lesperiode
        self.groep = groep
        self.studieInfo = studieInfo
    }
    
    convenience init(json:JSON?) {
        self.init(id: json?["Id"].int, leerlingId: json?["LeerlingId"].int, start: json?["Start"].string, einde: json?["Einde"].string, lesperiode: json?["Lesperiode"].string, groep: Group(json: json?["Groep"]), studieInfo: StudyInfo(json: json?["Studie"]))
    }
}

