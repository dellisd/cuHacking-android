//
//  NSExpression+Ext.swift
//  cuHacking
//
//  Created by Santos on 2019-07-31.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    ///  This method formats a string to use the MGL_Match method in mapbox which can be used for create an NSExpression
    /// - Parameters:
    ///   - attribute: The property of the feautre in Mapbox eg. roomType
    ///   - keys:  The keys to look for in the propery eg. washroom
    ///   - stringFormat:  the format of the string
    ///   - includeDefault:  indicates whether or not a default value is included 
    static func formatMGLMatchExpression(attribute: String, keys: [String], stringFormat: String, includeDefault: Bool) -> String {
        var format = "MGL_MATCH(\(attribute),"
        for key in keys {
            format += "'\(key)',\(stringFormat),"
        }
        if includeDefault {
            format += "\(stringFormat)"
        } else {
            format = String(format.dropLast())
        }
        format += ")"
        print("format:\(format)")
        return format
    }

    var qrCode: UIImage? {
        let data = self.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
