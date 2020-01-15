//
//  MapViewModel.swift
//  cuHacking
//
//  Created by Santos on 2019-07-15.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import Mapbox
import SwiftyJSON

class MapViewModel {
    var buildings: [Building] = []
    
    //Creates a view model object by fetching map data and using it to create building objects.
    public static func create(dataSource: MapRepository = MapDataSource(), completionHandler: @escaping(MapViewModel?, Error?) -> Void) {
        let mapViewModel = MapViewModel()
        dataSource.getMap { (json, error) in
            if error != nil {
                print(error?.localizedDescription)
                completionHandler(nil, error)
                return
            }
            guard let json = json else {
                return
            }
            for (key, buildingJSON):(String, JSON) in json["map"]["map"] {
                do {
                    let buildingData = try buildingJSON["geometry"].rawData()
                    if let shapeCollectionFeature = try MGLShape(data: buildingData, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature {
                        let center = CLLocation(latitude: Double(buildingJSON["center"][1].doubleValue),
                                                              longitude: Double(buildingJSON["center"][0].doubleValue))
                        var floors: [Building.Floor] = []
                        for(_, floorJSON):(String, JSON) in buildingJSON["floors"] {
                            floors.append(Building.Floor(id: floorJSON["id"].stringValue, name: floorJSON["name"].stringValue))
                        }
                        let building = Building(named: key, featureCollection: shapeCollectionFeature, center: center, floors: floors)
                        mapViewModel.buildings.append(building)
                    }
                } catch {
                    
                }
            }
            completionHandler(mapViewModel, nil)
            
        }
    }

}
