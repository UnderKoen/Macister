//
//  School.swift
//  AtcMagister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class School: NSObject {
    var url:String
    var name:String
    var id:String
    
    init(url:String, name:String, id:String) {
        self.url = url
        self.name = name
        self.id = id
    }
}
