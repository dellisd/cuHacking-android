//
//  Information.swift
//  cuHacking
//
//  Created by Santos on 2020-01-07.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
//These objects represent the Information object returned from the api.
extension MagnetonAPIObject {
    struct InformationResult: Codable {
        let version: String
        let info: Information
    }
    struct Information: Codable {
        let wifi: Wifi
        let emergency: String
        let help: String
        let social: Social
        let amountOfInformation = 4
    }
    struct Wifi: Codable {
        let network: String
        let password: String
    }
    struct Social: Codable {
        let twitter: String
        let facebook: String
        let instagram: String
        let slack: String
    }
}
