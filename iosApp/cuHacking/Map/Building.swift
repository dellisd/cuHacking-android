//
//  Building.swift
//  cuHacking
//
//  Created by Santos on 2020-01-08.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
import Mapbox

//This represents a building in Mapbox
final class Building {
    struct Floor {
        let id: String
        let name: String
    }
    let name: String
    let shapeSource: MGLShapeSource
    var currentFloor: Floor?
    var currentIndex: Int? {
        guard let currentFloor = currentFloor else {
            return nil
        }
        for index in 0..<floors.count where floors[index].name == currentFloor.name {
            return index
        }
        return nil
    }
    // The following predicates are used as filter in Mapbox
    // More info on predicates/expressions in MapBox can be found here: https://mapbox.github.io/mapbox-gl-native/macos/0.12.0/predicates-and-expressions.html
    var backdropLinePredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'backdrop-line'")
    }
    var symbolPredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND label = TRUE")
    }
    var linePredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'line'")
    }
    var floorPredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'room'")
    }
    var backdropPredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'backdrop'")
    }
    var fillFormat: String
    var symbolIconFormat: String
    var labelFormat: String

    let center: CLLocation
    let floors: [Floor]
    init(named name: String, featureCollection building: MGLShapeCollectionFeature, center: CLLocation, floors: [Floor]) {
        self.center = center
        self.floors = floors
        self.name = name
        self.shapeSource = MGLShapeSource(identifier: name, shape: building, options: nil)

        let fillKeys = ["room", "washroom", "elevator", "hallway", "stairs"]

        fillFormat =  String.formatMGLMatchExpression(attribute: "roomType", keys: fillKeys, stringFormat: "%@", includeDefault: true)
        let symbolKeys = ["washroom", "elevator", "stairs"]

        symbolIconFormat = String.formatMGLMatchExpression(attribute: "roomType", keys: symbolKeys, stringFormat: "%@", includeDefault: true)
        labelFormat = ""
        if let firstFloor = floors.first {
            currentFloor = firstFloor
        }
    }
    func hasFloor(named name: String) -> Bool {
        for floor in floors where floor.name == name {
            return true
        }
        return false
    }
}
