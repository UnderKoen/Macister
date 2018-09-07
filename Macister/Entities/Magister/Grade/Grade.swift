//
//  Study.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

//Cijferoverzicht, Laaste cijfers, Apart cijfer, Recent cijfer
class Grade: NSObject {
    var id: Int?
    var omschrijving: String?
    var cijferStr: String?
    var isVoldoende: Bool?
    var ingevoerdDoor: Any?
    var datumIngevoerd: String?
    var datumIngevoerdDate: Date?
    var cijferPeriode: GradePeriod?
    var vak: Subject?
    var inhalen: Bool?
    var vrijstelling: Bool?
    var teltMee: Bool?
    var cijferKolom: GradeColomn?
    var cijferKolomIdEloOpdracht: Int?
    var weegfactor: Int?
    var docent: String?
    var vakDispensatie: Bool?
    var vakVrijstelling: Bool?

    init(id: Int?, omschrijving: String?, cijferStr: String?, isVoldoende: Bool?, ingevoerdDoor: Any?, datumIngevoerd: String?, cijferPeriode: GradePeriod?, vak: Subject?, inhalen: Bool?, vrijstelling: Bool?, teltMee: Bool?, cijferKolom: GradeColomn?, cijferKolomIdEloOpdracht: Int?, weegfactor: Int?, docent: String?, vakDispensatie: Bool?, vakVrijstelling: Bool?) {
        self.id = id
        self.omschrijving = omschrijving
        self.cijferStr = cijferStr
        self.isVoldoende = isVoldoende
        self.ingevoerdDoor = ingevoerdDoor
        self.datumIngevoerd = datumIngevoerd
        if datumIngevoerd != nil {
            self.datumIngevoerdDate = DateUtil.getDateFromMagisterString(date: datumIngevoerd!)
        }
        self.cijferPeriode = cijferPeriode
        self.vak = vak
        self.inhalen = inhalen
        self.vrijstelling = vrijstelling
        self.teltMee = teltMee
        self.cijferKolom = cijferKolom
        self.cijferKolomIdEloOpdracht = cijferKolomIdEloOpdracht
        self.weegfactor = weegfactor
        self.docent = docent
        self.vakDispensatie = vakDispensatie
        self.vakVrijstelling = vakVrijstelling
    }

    convenience init(json: JSON?) {
        self.init(id: json?["CijferId"].int, omschrijving: json?["omschrijving"].string ?? json?["WerkInformatieOmschrijving"].string, cijferStr: json?["CijferStr"].string ?? json?["waarde"].string, isVoldoende: json?["IsVoldoende"].bool ?? json?["isVoldoende"].bool ?? json?["IsCijferVoldoende"].bool, ingevoerdDoor: json?["IngevoerdDoor"].object, datumIngevoerd: json?["DatumIngevoerd"].string ?? json?["WerkinformatieDatumIngevoerd"].string ?? json?["ingevoerdOp"].string, cijferPeriode: GradePeriod(json: json?["CijferPeriode"]), vak: Subject(json: JsonUtil.getJson(json?["Vak"], json?["vak"])), inhalen: json?["Inhalen"].bool ?? json?["moetInhalen"].bool, vrijstelling: json?["Vrijstelling"].bool ?? json?["heeftVrijstelling"].bool, teltMee: json?["TeltMee"].bool ?? json?["teltMee"].bool, cijferKolom: GradeColomn(json: JsonUtil.getJson(json?["CijferKolom"], json)), cijferKolomIdEloOpdracht: json?["CijferKolomIdEloOpdracht"].int, weegfactor: json?["Weging"].int ?? json?["weegfactor"].int, docent: json?["Docent"].string, vakDispensatie: json?["VakDispensatie"].bool, vakVrijstelling: json?["VakVrijstelling"].bool)
    }
}

