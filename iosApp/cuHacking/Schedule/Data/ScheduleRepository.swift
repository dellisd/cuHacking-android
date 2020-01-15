//
//  ScheduleRepository.swift
//  cuHacking
//
//  Created by Santos on 2019-12-02.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
protocol ScheduleRepository {
    func getEvents(completionHandler: @escaping (MagnetonAPIObject.Events?, Error?) -> Void)
}
