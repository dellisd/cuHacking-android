//
//  ScheduleDataSource.swift
//  cuHacking
//
//  Created by Santos on 2019-12-02.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
class ScheduleDataSource: ScheduleRepository {
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200

    func getEvents(completionHandler: @escaping (MagnetonAPIObject.Events?, Error?) -> Void) {
        let baseURL = ScheduleDataSource.baseURL + "/schedule"
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != ScheduleDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to fetch updates. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }
            let events: MagnetonAPIObject.Events?

            do {
                events = try JSONDecoder().decode(MagnetonAPIObject.Events.self, from: data)
                completionHandler(events, nil)

            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
    }
}
