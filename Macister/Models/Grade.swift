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
    var done: Bool = false

    var id: Int?
    var cijferStr: String?
    var isVoldoende: Bool?
    var ingevoerdDoor: Any?
    var datumIngevoerd: String?
    var datumIngevoerdDate: Date?
    //var cijferPeriode:GradePeriod?
    //var vak:Subject?
    var inhalen: Bool?
    var vrijstelling: Bool?
    var teltMee: Bool?
    //var cijferKolom:GradeColomn?
    var cijferKolomIdEloOpdracht: Int?
    var docent: String?
    var vakDispensatie: Bool?
    var vakVrijstelling: Bool?

    init(id: Int?, cijferStr: String?, isVoldoende: Bool?, ingevoerdDoor: Any?, datumIngevoerd: String?, /*cijferPeriode:GradePeriod?, vak:Subject?, */inhalen: Bool?, vrijstelling: Bool?, teltMee: Bool?, /*cijferKolom:GradeColomn?, */ cijferKolomIdEloOpdracht: Int?, docent: String?, vakDispensatie: Bool?, vakVrijstelling: Bool?) {
        self.id = id
        self.cijferStr = cijferStr
        self.isVoldoende = isVoldoende
        self.ingevoerdDoor = ingevoerdDoor
        self.datumIngevoerd = datumIngevoerd
        self.datumIngevoerdDate = DateUtil.getDateFromString(date: datumIngevoerd!)
        //self.cijferPeriode = cijferPeriode
        //self.vak = vak
        self.inhalen = inhalen
        self.vrijstelling  = vrijstelling
        self.teltMee = teltMee
        //self.cijferKolom = cijferKolom
        self.cijferKolomIdEloOpdracht = cijferKolomIdEloOpdracht
        self.docent = docent
        self.vakDispensatie  = vakDispensatie
        self.vakVrijstelling = vakVrijstelling
    }
    
    convenience init(json:JSON?) {
        self.init(id: json?["CijferId"].int, cijferStr: json?["CijferStr"].string, isVoldoende: json?["IsVoldoende"].bool, ingevoerdDoor: json?["IngevoerdDoor"], datumIngevoerd: json?["DatumIngevoerd"].string, inhalen: json?["Inhalen"].bool, vrijstelling: json?["Vrijstelling"].bool, teltMee: json?["TeltMee"].bool, cijferKolomIdEloOpdracht: json?["CijferKolomIdEloOpdracht"].bool, docent: json?["Docent"].bool, vakDispensatie: json?["VakDispensatie"].bool, vakVrijstelling: json?["VakVrijstelling"].bool)
    }
}

