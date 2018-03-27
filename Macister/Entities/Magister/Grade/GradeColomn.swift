//
//  GradeColomn.swift
//  Macister
//
//  Created by Koen van Staveren on 29/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class GradeColomn: NSObject {
    var id:Int?
    var kolomNaam:String?
    var kolomNummer:String?
    var kolomVolgNummer:String?
    var kolomKop:String?
    var kolomOmschrijving:String?
    var kolomSoort:RowType?
    var isHerkansingKolom:Bool?
    var isDocentKolom:Bool?
    var heeftOnderliggendeKolommen:Bool?
    var isPTAKolom:Bool?
    
    init(id:Int?, kolomNaam:String?, kolomNummer:String?, kolomVolgNummer:String?, kolomKop:String?, kolomOmschrijving:String?, kolomSoort:RowType?, isHerkansingKolom:Bool?, isDocentKolom:Bool?, heeftOnderliggendeKolommen:Bool?, isPTAKolom:Bool?) {
        self.id = id
        self.kolomNaam = kolomNaam
        self.kolomNummer = kolomNummer
        self.kolomVolgNummer = kolomVolgNummer
        self.kolomKop = kolomKop
        self.kolomOmschrijving = kolomOmschrijving
        self.kolomSoort = kolomSoort
        self.isHerkansingKolom = isHerkansingKolom
        self.isDocentKolom = isDocentKolom
        self.heeftOnderliggendeKolommen = heeftOnderliggendeKolommen
        self.isPTAKolom = isPTAKolom
    }
    
    convenience init(json:JSON?) {
        self.init(id: json?["Id"].int, kolomNaam: json?["KolomNaam"].string, kolomNummer: json?["KolomNummer"].string, kolomVolgNummer: json?["KolomVolgNummer"].string, kolomKop: json?["KolomKop"].string ?? json?["KolomKopnaam"].string, kolomOmschrijving: json?["KolomOmschrijving"].string, kolomSoort: RowType(rawValue: json?["KolomSoort"].int ?? json?["KolomSoortKolom"].int ?? 0), isHerkansingKolom: json?["IsHerkansingKolom"].bool, isDocentKolom: json?["IsDocentKolom"].bool, heeftOnderliggendeKolommen: json?["HeeftOnderliggendeKolommen"].bool, isPTAKolom: json?["IsPTAKolom"].bool)
    }
}

