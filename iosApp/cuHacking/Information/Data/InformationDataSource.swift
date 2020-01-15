//
//  InformationDataSource.swift
//  cuHacking
//
//  Created by Santos on 2020-01-07.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
class InformationDataSource: InformationRepository {
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200
    private static let cache = Cache<String, MagnetonAPIObject.InformationResult>()

    func getInformation(completionHandler: @escaping (MagnetonAPIObject.InformationResult?, Error?) -> Void) {
        let baseURL = InformationDataSource.baseURL + "/info"
        guard let url = URL(string: baseURL) else { return }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != InformationDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to fetch info. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }
            let information: MagnetonAPIObject.InformationResult?

            do {
                information = try JSONDecoder().decode(MagnetonAPIObject.InformationResult.self, from: data)
                completionHandler(information, nil)        
            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
    }
    
}
