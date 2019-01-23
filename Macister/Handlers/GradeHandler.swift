//
//  GradeHandler.swift
//  Macister
//
//  Created by Koen van Staveren on 05/02/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class GradeHandler: NSObject {
    var magister: Magister

    init(magister: Magister) {
        self.magister = magister
    }

    func getLastGrades() -> Future<Grades> {
        return HttpUtil.httpGet(url: magister.getMainUrl().personUrl!.getLastGradesUrl())
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    return Grades(json: json)
                }
    }

    func getAverageGrades() -> Future<Grades> {
        return HttpUtil.httpGet(url: magister.getMainUrl().currentStudyUrl!.getGratesUrl(), parameters: ["actievePerioden": "false", "alleenBerekendeKolommen": "true", "alleenPTAKolommen": "false"])
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    return Grades(json: json)
                }
    }
}
