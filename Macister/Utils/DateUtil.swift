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
}
