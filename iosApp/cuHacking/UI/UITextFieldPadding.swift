//
//  UITextFieldPadding.swift
//  cuHacking
//
//  Created by Santos on 2020-01-02.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit

class UITextFieldPadding: UITextField {

  let padding = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
