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
    
    static func getDateFormatLesson() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    static func getDateFormatLessons() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        return dateFormatter
    }
    
    static func getDateFormatMail() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'-'MM HH:mm"
        return dateFormatter
    }
    
    static func getDateFormatToday() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        return dateFormatter
    }
    
    static func getDateFromMagisterString(date: String) -> Date {
        let date = getDateFormatMagister().date(from: date)!
        return date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT(for: date)))
    }
    
    static func getLessonTime(lesson: Lesson) -> String {
        let format = getDateFormatLesson()
        return format.string(from: lesson.startDate!) + " - " + format.string(from: lesson.eindeDate!)
    }
}
