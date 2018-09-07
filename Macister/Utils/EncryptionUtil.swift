//
//  EncryptionUtil.swift
//  Macister
//
//  Created by Koen van Staveren on 20/03/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import RNCryptor

class EncryptionUtil: NSObject {
    static func encryptMessage(message: String, encryptionKey: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }

    static func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!

        return decryptedString
    }
}
