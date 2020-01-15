//
//  ProfileDataSource.swift
//  cuHacking
//
//  Created by Santos on 2019-09-02.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
class ProfileDataSource: ProfileRepository {
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200
    struct Header {
        static let AUTHORIZATION = "Authorization"
        static let BEARER = "Bearer "
    }
    func getUserProfile(token: String, completionHandler: @escaping (MagnetonAPIObject.UserProfile?, Error?) -> Void) {
        let baseURL = ProfileDataSource.baseURL + "/users/profile"
        var requestURL = URLRequest(url: URL(string: baseURL)!)
        requestURL.httpMethod = "GET"
        requestURL.allHTTPHeaderFields = [Header.AUTHORIZATION: Header.BEARER + token]

        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != ProfileDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to fetch profile. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }
            let profile: MagnetonAPIObject.UserProfile?

            do {
                profile = try JSONDecoder().decode(MagnetonAPIObject.UserProfile.self, from: data)
                completionHandler(profile, nil)

            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
    }
}
    
    
//    func getUserProfile() -> MagnetonAPIObject.UserProfile {
//        let blankUser = MagnetonAPIObject.UserProfile(
//            operation: "get",
//            status: "500",
//            data: MagnetonAPIObject.UserProfile.Data(
//                username: "",
//                role: "",
//                uid: "")
//        )
//        guard let filePath = Bundle.main.path(forResource: "UserProfile", ofType: "json") else {
//            return blankUser
//        }
//        do {
//            let url = URL(fileURLWithPath: filePath)
//            let data = try Data(contentsOf: url)
//            let userProfile = try JSONDecoder().decode(MagnetonAPIObject.UserProfile.self, from: data)
//
//            return userProfile
//
//        } catch {
//            print("Error: \(error)")
//            return blankUser
//        }
//    }
    
//}
