//
//  QRScannerDataSource.swift
//  
//
//  Created by Santos on 2020-01-07.
//

import Foundation
class QRScannerDataSource: QRScannerRepository {
    enum Results {
        case success
        case alreadyScanned
        case userNotFound
        case serverError
        case error
    }
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200

    func scan(token:String, uuid: String, eventID: String, completionHandler: @escaping (QRScannerDataSource.Results, Error?) -> Void) {
        let baseURL = QRScannerDataSource.baseURL + "/scan"
        var requestURL = URLRequest(url: URL(string: baseURL)!)
        requestURL.httpMethod = "POST"
        let body: [String: Any] = ["uid": uuid, "eventId": eventID]
        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        requestURL.httpBody = bodyData
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.allHTTPHeaderFields = [ProfileDataSource.Header.AUTHORIZATION: ProfileDataSource.Header.BEARER + token]

        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if error != nil {
                completionHandler(.error, error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.error, nil)
                return
            }
            switch response.statusCode {
            case 200:
                completionHandler(.success, nil)
            case 400:
                completionHandler(.alreadyScanned, nil)
            case 404:
                completionHandler(.userNotFound, nil)
            case 500:
                completionHandler(.serverError, nil)
            default:
                completionHandler(.error, nil)
            }
            return
        }.resume()
    }
}
