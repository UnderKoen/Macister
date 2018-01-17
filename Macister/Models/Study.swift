//
//  Study.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Study: NSObject {
    var id:Int?
    var leerlingId:Int?
    
    var start:String?
    var startDate:Date?
    
    var einde:String?
    var eindeDate:Date?
    
    var lesperiode:String?
    var groep:Group?
    var studieInfo:StudyInfo?
    
    init(id:Int?, leerlingId:Int?, start:String?, einde:String?, lesperiode:String?, groep:Group?, studieInfo:StudyInfo?) {
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
