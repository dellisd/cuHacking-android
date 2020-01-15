//
//  GeoJSONLoader.swift
//  cuHacking
//
//  Created by Santos on 2019-07-18.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import Mapbox
import SwiftyJSON

class MapDataSource: MapRepository {
    enum Error: Swift.Error {
        case invalidFileName(message: String)
        case invalidGeoJSON(message: String)
        case deserializationFailed(message: String)
    }
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200

    func getMap(completionHandler: @escaping (JSON?, Swift.Error?) -> Void) {
        let baseURL = MapDataSource.baseURL + "/map"
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != MapDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to fetch map. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }
            var map: JSON?

            do {
                map = try JSON(data: data)
                // Mapbox uses NSExpressions so when working with kebab-case values, it will fail to parse
                // because it treats the `-` as if it were a minus sign so we had to replace the kebab with camel.
                // This is onyl relevant if you plan on using the property in MapBox
                if let cleanString = map?.rawString()?.replacingOccurrences(of: "room-type", with: "roomType"),
                    let cleanData = cleanString.data(using: .utf8){
                    map = try JSON(data: cleanData)
                }
                completionHandler(map, nil)

            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
    }
}
