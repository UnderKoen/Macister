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
    var magister: Magister

    init(magister: Magister) {
        self.magister = magister
    }

    func getMail(mapId: Int, top: Int?, skip: Int?) -> Future<[Message]> {
        return HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getMailUrl())!, parameters: ["mapId": mapId, "top": top ?? "", "skip": skip ?? ""])
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    var mail: [Message] = [Message]()

                    json["Items"].array?.forEach({ (jsonF) in
                        mail.append(Message(json: jsonF))
                    })

                    mail.sort(by: { (mail1, mail2) -> Bool in
                        return mail2.verstuurdOpDate!.timeIntervalSince(mail1.verstuurdOpDate!) < 0
                    })
                    return mail
                }
    }

    func getSingleMail(message: Message) -> Future<Message> {
        return HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!, parameters: ["berichtSoort": message.soort!.rawValue])
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    return Message(json: json)
                }
    }

    func moveMail(message: Message, toMapId: Int) -> Future<Message> {
        var para = message.json.dictionaryObject!
        para["MapId"] = toMapId
        return HttpUtil.httpPut(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!, parameters: para)
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    return Message(json: json)
                }
    }

    func deleteMail(message: Message) -> Future<NSNull> {
        return HttpUtil.httpDelete(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!)
            .done()
    }

    func markRead(message: Message, read: Bool) -> Future<Message> {
        var para = message.json.dictionaryObject!
        para["IsGelezen"] = read
        return HttpUtil.httpPut(url: (magister.getMainUrl().personUrl?.getSingleMailUrl(message.id!))!, parameters: para)
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    return Message(json: json)
                }
    }

    func getUnread(mapId: Int) -> Future<Int> {
        return HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getMailUrl())!, parameters: ["count": "true", "gelezen": "false", "mapId": "\(mapId)"])
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    return json["TotalCount"].int!
                }
    }

    static let download = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

    func downloadBijlage(bijlage: Bijlage, progressHandler: @escaping (Progress) -> () = { _ in
    }) -> Future<NSNull> {
        return HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getMailBijlagenUrl(bijlage.id ?? 0))!, parameters: ["redirect_type":"body"])
            .map { response throws in
                return try JSON(data: response.data!)
            }
            .map { json in
                return json["location"].stringValue
            }
            .flatMap { url in
                return HttpUtil.httpGetFile(url: url, fileName: bijlage.naam ?? "", location: MailHandler.download, override: false, progressHandler: progressHandler)
            }
            .done()
    }

}
