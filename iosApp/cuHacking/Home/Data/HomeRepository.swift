//
//  InformationRepository.swift
//  cuHacking
//
//  Created by Santos on 2019-07-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
protocol HomeRepository {
    func getUpdates(completionHandler: @escaping (MagnetonAPIObject.Updates?, Error?) -> Void)   	
}
