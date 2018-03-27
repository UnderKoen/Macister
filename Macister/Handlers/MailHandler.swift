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
}
