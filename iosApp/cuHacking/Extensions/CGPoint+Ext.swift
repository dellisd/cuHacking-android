//
//  CGPoint+Ext.swift
//  cuHacking
//
//  Created by Santos on 2020-01-08.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
import Mapbox
extension CLLocationCoordinate2D {
    func distanceSquared(to: CLLocationCoordinate2D) -> Double {
        let left = (longitude - to.longitude) * (longitude - to.longitude)
        let right = (latitude - to.latitude) * (latitude - to.latitude)
        return left + right
    }
    func distance(to: CLLocationCoordinate2D) -> Double {
        return sqrt(distanceSquared(to: to))
    }
}
