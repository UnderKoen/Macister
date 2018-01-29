//
//  DateUtil.swift
//  Macister
//
//  Created by Koen van Staveren on 16/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class DateUtil: NSObject {
    static func getDateFormatMagister() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH:mm:ss.SSSSSSS'Z'"
        return dateFormatter
    }
    
    static func getDateFromMagisterString(date: String) -> Date {
        return getDateFormatMagister().date(from: date)!
    }
    
    static func getDateFormatLesson() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    static func getLessonTime(lesson: Lesson) -> String {
        let format = getDateFormatLesson()
        return format.string(from: lesson.startDate!) + " - " + format.string(from: lesson.eindeDate!)
    }
}
