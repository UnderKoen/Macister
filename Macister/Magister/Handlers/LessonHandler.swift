//
//  Lesson Handler.swift
//  Macister
//
//  Created by Koen van Staveren on 29/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa
import SwiftyJSON

class LessonHandler: NSObject {
    var magister:Magister
    
    init(magister:Magister) {
        self.magister = magister
    }
    
    func getLessonsToday(completionHandler: @escaping ([Lesson]) -> () = { _ in }) {
        getLessonsForDay(day: Date(), completionHandler: completionHandler)
    }
    
    func getLessonsForDay(day:Date, completionHandler: @escaping ([Lesson]) -> () = { _ in }) {
        getLessons(from: day, until: day, completionHandler: completionHandler)
    }
    
    func getLessons(from:Date, until:Date, completionHandler: @escaping ([Lesson]) -> () = { _ in }) {
        let format = DateUtil.getDateFormatLessons()
        HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getLessonsUrl())!, parameters: ["van":format.string(from: from), "tot":format.string(from: until), "status":1]) { (response) in
            var lessons:[Lesson] = [Lesson].init()
            do {
                let json = try JSON(data: response.data!)
                json["Items"].array?.forEach({ (jsonF) in
                    lessons.append(Lesson.init(json: jsonF))
                })
            } catch {}
            completionHandler(lessons)
        }
    }
    
}
