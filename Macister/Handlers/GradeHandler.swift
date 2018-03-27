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
    var magister:Magister
    
    init(magister:Magister) {
        self.magister = magister
    }
    
    func getLastGrades(completionHandler: @escaping (Grades?) -> () = { _ in }) {
        HttpUtil.httpGet(url: magister.getMainUrl().personUrl!.getLastGradesUrl()) { (response) in
            do {
                let json = try JSON(data: response.data!)
                completionHandler(Grades(json: json))
                return
            } catch {}
            completionHandler(nil)
        }
    }
    
    func getAverageGrades(completionHandler: @escaping (Grades?) -> () = { _ in }) {
        HttpUtil.httpGet(url: magister.getMainUrl().currentStudyUrl!.getGratesUrl(), parameters: ["actievePerioden":"false","alleenBerekendeKolommen":"true","alleenPTAKolommen":"false"]) { (response) in
            do {
                let json = try JSON(data: response.data!)
                completionHandler(Grades(json: json))
                return
            } catch {}
            completionHandler(nil)
        }
    }
}
