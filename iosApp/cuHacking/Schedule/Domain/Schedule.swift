//
//  Schedule.swift
//  cuHacking
//
//  Created by Santos on 2019-12-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//
import Foundation
import UIKit
struct Day {
    let name: String
    let events: [MagnetonAPIObject.Event]
}
extension MagnetonAPIObject {
    struct Events: Codable {
        let version: String
        let schedule: [String: Event]
        public var orderedEvents: [Day] {
            var events: [Event] = Array(schedule.values)
            if !UserAccess.isAdmin {
                events = events.filter({ (event) -> Bool in
                    return !(event.type == "admin" || event.type == "Volunteer")
                })
            }
            //Group events by their day
            var groupedEvents: [String: [Event]] = Dictionary.init(grouping: events) { (event) in
                guard let date = event.startDate else {
                    return ""
                }
                let dayFormat = DateFormatter()
                dayFormat.dateFormat = "EEEE, MMMM dd"
                return dayFormat.string(from: date)
            }
            //Sort events in the same day by their start time
            groupedEvents = groupedEvents.mapValues { (events) -> [Event] in
                events.sorted { (left, right) -> Bool in
                    guard let leftStartDate = left.startDate, let rightStartDate = right.startDate,
                        let leftEndDate = left.endDate, let rightEndDate = right.endDate else {
                        return false
                    }
                    if leftStartDate == rightStartDate {
                        return leftEndDate <= rightEndDate
                    }
                    return leftStartDate <= rightStartDate
                }
            }
            //Create Day objects from keys
            let sortedKey = groupedEvents.keys.sorted { (left, right) -> Bool in
                let dayFormat = DateFormatter()
                dayFormat.dateFormat = "EEEE, MMMM dd"
                guard let leftDate = dayFormat.date(from: left),
                    let rightDate = dayFormat.date(from: right) else {
                        return false
                }
                return leftDate <= rightDate
            }

            let sortedDays = sortedKey.map { (key) -> Day in
                let events = groupedEvents[key]!
                return Day(name: key, events: events)
            }
            return sortedDays
        }
        public var scannableEvents: [Event] {
            var events = Array(schedule.values)
            events = events.filter({ (event) -> Bool in
                return event.scan
            })
            events = events.filter({ (event) -> Bool in
                guard let now = DateFormatter.RFC3339DateFormatter.date(from: DateFormatter.RFC3339DateFormatter.string(from: Date())),
                    let endDate = event.endDate else {
                    return false
                }
                return now <= endDate
            })
            events = events.sorted(by: { (left, right) -> Bool in
                guard let leftDate = left.startDate, let rightDate = right.startDate else {
                    return false
                }
                return leftDate <= rightDate
            })
            return events
        }
    }

    struct Event: Codable, Hashable {
        let description: String
        let location: String
        let startTime: String
        let endTime: String
        let title: String
        let type: String
        let countdown: Bool
        let scan: Bool
        let id: String?
        var color: UIColor {
            switch type {
            case "Workshop":
                return Asset.Colors.greenEvent.color
            case "Key Events":
                return Asset.Colors.purple.color
            case "Sponsor Event":
                return Asset.Colors.sponsor.color
            case "Social Activity":
                return Asset.Colors.blueEvent.color
            case "Food":
                return Asset.Colors.redEvent.color
            case "Volunteer":
                return UIColor.orange
            default:
                return UIColor.black
            }
        }

        var startDate: Date? {
            guard let date = DateFormatter.RFC3339DateFormatter.date(from: startTime) else {
                return nil
            }
            return date
        }

        var endDate: Date? {
            guard let date = DateFormatter.RFC3339DateFormatter.date(from: endTime) else {
                return nil
            }
            return date
        }

        var formattedStartTime: String {
            guard let date = startDate else {
                return startTime
            }
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)

            if minute == 0 {
                return "\(hour):\(minute)0"
            } else {
                return "\(hour):\(minute)"
            }
        }
        var formattedEndTime: String {
            guard let date = endDate else {
                return endTime
            }
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            if minute == 0 {
                return "\(hour):\(minute)0"
            } else {
                return "\(hour):\(minute)"
            }
        }
        var formattedDuration: String {
            return "\(formattedStartTime) - \(formattedEndTime)"
        }
    }
}
