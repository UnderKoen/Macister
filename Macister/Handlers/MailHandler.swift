//
//  MailHandler.swift
//  Macister
//
//  Created by Koen van Staveren on 21/03/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class MailHandler: NSObject {
    var magister:Magister
    
    init(magister:Magister) {
        self.magister = magister
    }
    
    func getMail(mapId:Int, top:Int?, skip:Int?, completionHandler: @escaping ([Message]) -> () = { _ in }) {
        HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getMailUrl())!, parameters: ["mapId":mapId, "top":top ?? "", "skip":skip ?? ""]) { (response) in
            var mail:[Message] = [Message].init()
            do {
                let json = try JSON(data: response.data!)
                json["Items"].array?.forEach({ (jsonF) in
                    mail.append(Message.init(json: jsonF))
                })
            } catch {}
            mail.sort(by: { (mail1, mail2) -> Bool in
                return mail2.verstuurdOpDate!.timeIntervalSince(mail1.verstuurdOpDate!) < 0
            })
            completionHandler(mail)
        }
    }
    
    func getSingleMail(message:Message, completionHandler: @escaping (Message) -> () = { _ in }) {
        HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!, parameters: ["berichtSoort":message.soort!.rawValue]) { (response) in
            do {
                let json = try JSON(data: response.data!)
                let mail:Message = Message.init(json: json)
                completionHandler(mail)
            } catch {}
        }
    }
    
    func moveMail(message:Message, toMapId:Int, completionHandler: @escaping (Message) -> () = { _ in }) {
        var para = message.json.dictionaryObject!
        para["MapId"] = toMapId
        HttpUtil.httpPut(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!, parameters: para) { (response) in
            do {
                let json = try JSON(data: response.data!)
                let mail:Message = Message.init(json: json)
                completionHandler(mail)
            } catch {}
        }
    }
    
    func deleteMail(message:Message, completionHandler: @escaping () -> () = { }) {
        HttpUtil.httpDelete(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!) { (_) in
            completionHandler()
        }
    }
    
    func markRead(message:Message, read:Bool, completionHandler: @escaping (Message) -> () = { _ in }) {
        var para = message.json.dictionaryObject!
        para["IsGelezen"] = read
        HttpUtil.httpPut(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!, parameters: para) { (response) in
            do {
                let json = try JSON(data: response.data!)
                let mail:Message = Message.init(json: json)
                completionHandler(mail)
            } catch {}
        }
    }
}
