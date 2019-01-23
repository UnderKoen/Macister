//
//  School.swift
//  Macister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class School: NSObject {
    var url: String
    var name: String
    var id: String

    init(url: String, name: String, id: String) {
        self.url = url
        self.name = name
        self.id = id
    }

    static func findSchools(filter: String) -> Future<[School]> {
        return HttpUtil.httpGet(url: "https://mijn.magister.net/api/schools", parameters: ["filter": filter])
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map({ json in
                    var schools: [School] = []
                    json.array?.forEach({ (schoolJson) in
                        let school = School(url: schoolJson["Url"].string ?? "", name: schoolJson["Name"].string ?? "", id: schoolJson["Id"].string ?? "")
                        schools.append(school)
                    })

                    return schools
                })
    }

    override var description: String {
        get {
            return name
        }
    }
}
