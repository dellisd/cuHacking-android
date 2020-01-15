//
//  UIStackView+Ext.swift
//  cuHacking
//
//  Created by Santos on 2019-10-20.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        views.forEach { (view) in
            addArrangedSubview(view)
        }
    }
}
