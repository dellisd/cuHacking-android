//
//  InformationRepository.swift
//  cuHacking
//
//  Created by Santos on 2020-01-07.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
protocol InformationRepository {
    func getInformation(completionHandler: @escaping (MagnetonAPIObject.InformationResult?, Error?) -> Void)
}
