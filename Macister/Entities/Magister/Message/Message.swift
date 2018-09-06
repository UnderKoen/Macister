//
//  Message.swift
//  Macister
//
//  Created by Koen van Staveren on 07/02/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Message: NSObject {
    var json:JSON!
    
    var id:Int?
    var inhoud:String?
    var mapId:Int?
    var mapTitel:String?
    var onderwerp:String?
    var afzender:Contact?
    var ingekortBericht:Any?
    var ontvangers:[Contact]?
    var ontvangersStr:String?
    var verstuurdOp:String?
    var verstuurdOpDate:Date?
    var begin:String?
    var beginDate:Date?
    var einde:String?
    var eindeDate:Date?
    var isGelezen:Bool?
    var status:MessageStatusType?
    var heeftPrioriteit:Bool?
    var heeftBijlagen:Bool?
    var soort:MessageType?
    var toonOpVandaagscherm:Bool?
    
    init(json: JSON!, id:Int?, content:String?, mapId:Int?, mapTitel:String?, onderwerp:String?, afzender:Contact?, ingekortBericht:Any?, ontvangers:[Contact]?, verstuurdOp:String?, begin:String?,  einde:String?, isGelezen:Bool?, status:MessageStatusType?, heeftPrioriteit:Bool?, heeftBijlagen:Bool?, soort:MessageType?, toonOpVandaagscherm:Bool?) {
        self.json = json
        self.id = id
        self.inhoud = content
        self.mapId = mapId
        self.mapTitel = mapTitel
        self.onderwerp = onderwerp
        self.afzender = afzender
        self.ingekortBericht = ingekortBericht
        self.ontvangers = ontvangers
        self.verstuurdOp = verstuurdOp
        if (verstuurdOp != nil) {
            self.verstuurdOpDate = DateUtil.getDateFromMagisterString(date: verstuurdOp!)
        }
        self.begin = begin
        if (begin != nil) {
            self.beginDate = DateUtil.getDateFromMagisterString(date: begin!)
        }
        self.einde = einde
        if (einde != nil) {
            self.eindeDate = DateUtil.getDateFromMagisterString(date: einde!)
        }
        self.isGelezen = isGelezen
        self.status = status
        self.heeftPrioriteit = heeftPrioriteit
        self.heeftBijlagen = heeftBijlagen
        self.soort = soort
        self.toonOpVandaagscherm = toonOpVandaagscherm
        if (ontvangers != nil) {
            for contact in ontvangers! {
                if (ontvangersStr == nil) {
                    if (contact.naam != nil) {
                        self.ontvangersStr = "\(contact.naam!)"
                    }
                } else {
                    if (contact.naam != nil) {
                        self.ontvangersStr = "\(self.ontvangersStr!), \(contact.naam!)"
                    }
                }
            }
        }
    }
    
    convenience init(json:JSON?) {
        var ontvangers = [Contact]()
        (json?["Ontvangers"] ?? json?["KopieOntvangers"])?.array?.forEach({(jsonC) in
            ontvangers.append(Contact(json: jsonC))
        })
        self.init(json: json, id: json?["Id"].int, content: json?["Inhoud"].string, mapId: json?["MapId"].int, mapTitel: json?["MapTitel"].string, onderwerp: json?["Onderwerp"].string, afzender: Contact(json: json?["Afzender"]), ingekortBericht: json?["IngekortBericht"].object, ontvangers: ontvangers, verstuurdOp: json?["VerstuurdOp"].string, begin: json?["Begin"].string, einde: json?["Einde"].string, isGelezen: json?["IsGelezen"].bool, status: MessageStatusType(rawValue: json?["Status"].int ?? 0), heeftPrioriteit: json?["HeeftPrioriteit"].bool, heeftBijlagen: json?["HeeftBijlagen"].bool, soort: MessageType(rawValue: json?["Soort"].int ?? 0), toonOpVandaagscherm: json?["ToonOpVandaagscherm"].bool)
    }
}
