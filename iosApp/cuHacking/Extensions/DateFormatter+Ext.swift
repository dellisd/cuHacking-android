//
//  DateFormatter+Ext.swift
//  cuHacking
//
//  Created by Santos on 2020-01-06.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
extension DateFormatter {
    static var RFC3339DateFormatter: DateFormatter {
       let RFC3339DateFormatter = DateFormatter()
       RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
       RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
       RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return RFC3339DateFormatter
    }
    // This uses RFC3339 Formatting, without the seconds. This was needed because the
    // format of the announcement timestamps were different from the schedule timestamps.
    static var AnnouncementFormatter: DateFormatter {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return RFC3339DateFormatter
    }
}
