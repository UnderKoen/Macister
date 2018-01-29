//
//  Lesson.swift
//  Macister
//
//  Created by Koen van Staveren on 22/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Lesson: NSObject {
    var id:Int?
    var start:String?
    var startDate:Date?
    var einde:String?
    var eindeDate:Date?
    var lesuurVan:Int?
    var lesuurTotMet:Int?
    var duurtHeleDag:Bool?
    var omschrijving:String?
    var lokatie:String?
    var status:StatusType?
    var lessonType:LessonType?
    var weergaveType:DisplayType?
    var inhoud:String?
    var infoType:InfoType?
    var aantekening:Any?
    var afgerond:Bool?
    var vakken:[Subject]?
    var docenten:[Teacher]?
    var lokalen:[ClassRoom]?
    var groepen:Any?
    var opdrachtId:Int?
    var heeftBijlagen:Bool?
    var bijlagen:Any?
    
    init(id:Int?, start:String?, einde:String?, lesuurVan:Int?, lesuurTotMet:Int?, duurtHeleDag:Bool?, omschrijving:String?, lokatie:String?, status:StatusType?, lessonType:LessonType?, weergaveType:DisplayType?, inhoud:String?, infoType:InfoType?, aantekening:Any?, afgerond:Bool?, vakken:[Subject]?, docenten:[Teacher]?, lokalen:[ClassRoom]?, groepen:Any?, opdrachtId:Int?, heeftBijlagen:Bool?, bijlagen:Any?) {
        self.id = id
        self.start = start
        self.startDate = DateUtil.getDateFromMagisterString(date: start!)
        self.einde = einde
        self.eindeDate = DateUtil.getDateFromMagisterString(date: einde!)
        self.lesuurVan = lesuurVan
        self.lesuurTotMet = lesuurTotMet
        self.duurtHeleDag = duurtHeleDag
        self.omschrijving = omschrijving
        self.lokatie = lokatie
        self.status = status
        self.lessonType = lessonType
        self.weergaveType = weergaveType
        self.inhoud = inhoud
        self.infoType = infoType
        self.aantekening = aantekening
        self.afgerond = afgerond
        self.vakken = vakken
        self.docenten = docenten
        self.lokalen = lokalen
        self.groepen = groepen
        self.opdrachtId = opdrachtId
        self.heeftBijlagen = heeftBijlagen
        self.bijlagen = bijlagen
    }
    
    convenience init(json:JSON?) {
        var subjects:[Subject] = [Subject].init()
        json?["Vakken"].array?.forEach({ (jsonF) in
            subjects.append(Subject.init(json: jsonF))
        })
        var teachers:[Teacher] = [Teacher].init()
        json?["Vakken"].array?.forEach({ (jsonF) in
            teachers.append(Teacher.init(json: jsonF))
        })
        var classRooms:[ClassRoom] = [ClassRoom].init()
        json?["Vakken"].array?.forEach({ (jsonF) in
            classRooms.append(ClassRoom.init(json: jsonF))
        })
        self.init(id: json?["Id"].int, start: json?["Start"].string, einde: json?["Einde"].string, lesuurVan: json?["LesuurVan"].int, lesuurTotMet: json?["LesuurTotMet"].int, duurtHeleDag: json?["DuurtHeleDag"].bool, omschrijving: json?["Omschrijving"].string, lokatie: json?["Lokatie"].string, status: StatusType(rawValue: json?["Status"].int ?? 0), lessonType: LessonType(rawValue: (json?["Type"].int) ?? 0), weergaveType: DisplayType(rawValue: (json?["WeergaveType"].int) ?? 0), inhoud: json?["Inhoud"].string, infoType: InfoType(rawValue: (json?["InfoType"].int) ?? 0), aantekening: json?["Aantekening"].object, afgerond: json?["Afgerond"].bool, vakken: subjects, docenten: teachers, lokalen: classRooms, groepen: json?["Groepen"].object, opdrachtId: json?["OpdrachtId"].int, heeftBijlagen: json?["HeeftBijlagen"].bool, bijlagen: json?["Bijlagen"].object)
    }
}


