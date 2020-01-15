//
//  ProfileRepository.swift
//  cuHacking
//
//  Created by Santos on 2019-11-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
protocol ProfileRepository {
    func getUserProfile(token: String, completionHandler: @escaping (MagnetonAPIObject.UserProfile?, Error?) -> Void)
}

