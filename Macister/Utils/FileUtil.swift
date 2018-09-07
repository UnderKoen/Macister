//
//  FileUtil.swift
//  Macister
//
//  Created by Koen van Staveren on 15/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class FileUtil: NSObject {
    static func getApplicationFolder() -> URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0], isDirectory: true).appendingPathComponent("Macister")
    }
}
