//
//  JsonUtil.swift
//  Macister
//
//  Created by Koen van Staveren on 05/02/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class JsonUtil: NSObject {
    static func getJson(_ json1: JSON?, _ json2: JSON?) -> JSON? {
        if (json1 != JSON.null) {
            return json1
        } else if (json2 != JSON.null) {
            return json2
        } else {
            return nil
        }
    }
}
