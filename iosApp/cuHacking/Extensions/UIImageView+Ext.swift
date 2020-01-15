//
//  UIImageView+Ext.swift
//  cuHacking
//
//  Created by Santos on 2020-01-12.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit
extension UIImageView {
    func makeRounded() {
        let radius = bounds.height/2
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
