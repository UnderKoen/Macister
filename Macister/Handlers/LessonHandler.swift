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
    var magister: Magister

    init(magister: Magister) {
        self.magister = magister
    }

    func getLessonsToday() -> Future<[Lesson]> {
        return getLessonsForDay(day: Date())
    }

    func getLessonsForDay(day: Date) -> Future<[Lesson]> {
        return getLessons(from: day, until: day)
    }

    func getLessons(from: Date, until: Date) -> Future<[Lesson]> {
        let format = DateUtil.getDateFormatLessons()
        return HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getLessonsUrl())!, parameters: ["van": format.string(from: from), "tot": format.string(from: until), "status": 0])
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map({ json in
                    var lessons: [Lesson] = [Lesson]()
                    json["Items"].array?.forEach({ (jsonF) in
                        lessons.append(Lesson.init(json: jsonF))
                    })
                    lessons.sort(by: { (lesson1, lesson2) -> Bool in
                        return lesson1.startDate!.timeIntervalSince(lesson2.startDate!) < 0
                    })
                    return lessons
                })
    }

    func getLesson(lesson: Lesson) -> Future<Lesson> {
        return HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getSingleLessonUrl(lesson.id!))!)
                .map { response throws in
                    return try JSON(data: response.data!)
                }
                .map { json in
                    return Lesson(json: json)
                }
    }
    
    func downloadBijlage(bijlage: Bijlage, progressHandler: @escaping (Progress) -> () = { _ in
        }) -> Future<NSNull> {
        return HttpUtil.httpGet(url: (magister.getMainUrl().personUrl?.getLessonBijlagenUrl(bijlage.id ?? 0))!, parameters: ["redirect_type":"body"])
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
