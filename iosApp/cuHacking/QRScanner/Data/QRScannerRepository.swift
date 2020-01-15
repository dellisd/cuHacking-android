//
//  QRScannerRepository.swift
//  cuHacking
//
//  Created by Santos on 2020-01-07.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
protocol QRScannerRepository {
    func scan(token:String, uuid: String, eventID: String, completionHandler: @escaping (QRScannerDataSource.Results, Error?) -> Void) 
}
