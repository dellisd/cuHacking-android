//
//  InformationDataSource.swift
//  cuHacking
//
//  Created by Santos on 2019-11-30.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
enum MagnentonError: Error {
    case fetch(message: String)
    case data(message: String)
}
class HomeDataSource: HomeRepository {
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200
    
    /// Gets the updates for the event. These updates are displayed on the Home tab under the Announcements section
    /// - Parameter completionHandler: The method to be called once there is some results 
    func getUpdates(completionHandler: @escaping (MagnetonAPIObject.Updates?, Error?) -> Void) {
        print(HomeDataSource.baseURL)
        let baseURL = HomeDataSource.baseURL + "/updates"
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != HomeDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to fetch updates. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }
            let updates: MagnetonAPIObject.Updates?

            do {
                updates = try JSONDecoder().decode(MagnetonAPIObject.Updates.self, from: data)
                completionHandler(updates, nil)

            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
    }
}
