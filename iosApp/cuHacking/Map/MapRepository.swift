//
//  MapRepostiroy.swift
//  cuHacking
//
//  Created by Santos on 2020-01-08.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
import SwiftyJSON
protocol MapRepository {
    func getMap(completionHandler: @escaping (JSON?, Error?) -> Void)
}
