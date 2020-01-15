//
//  Environment.swift
//  cuHacking
//
//  Created by Santos on 2019-12-15.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
public enum Environment {
    enum Keys: String {
        case rootURL = "ROOT_URL"
    }
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
          fatalError("Plist file not found")
        }
        return dict
    }()

    static let rootURL: URL = {
        guard let rootURLstring = Environment.infoDictionary[Keys.rootURL.rawValue] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
          fatalError("Root URL is invalid")
        }
        return url
    }()
}
