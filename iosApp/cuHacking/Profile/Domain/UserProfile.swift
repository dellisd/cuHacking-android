//
//  UserProfile.swift
//  cuHacking
//
//  Created by Santos on 2019-11-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import UIKit
struct MagnetonAPIObject {

    struct UserProfile: Codable {
        let data: MagnetonAPIObject.Data
    }
    
    struct Data: Codable {
        let role: String
        let color: String
        let application: Application
        let email: String

        var badgeColor: UIColor {
            switch color {
            case "red":
                return UIColor.red
            case "green":
                return UIColor.green
            case "blue":
                return UIColor.blue
            case "yellow":
                return UIColor.yellow
            default:
                return UIColor.black
            }
        }
    }
    
    struct Application: Codable {
        let basicInfo: BasicInfo
        let personalInfo: PersonalInfo
    }
    
    struct BasicInfo: Codable {
        let gender: String?
        let firstName: String?
        let ethnicity: String?
        let emergencyPhone: String?
        let otherEthnicity: String?
        let lastName: String?
        let otherGender: String?
    }
    
    struct Profile: Codable {
        let resume: Bool
        let website: String?
        let soughtPosition: String?
        let github: String?
    }

    struct PersonalInfo: Codable {
        let school: String?
        let dietaryRestrictions: DietaryRestrictions
    }
    
    struct DietaryRestrictions: Codable {
        let other: String?
        let glutenFree: Bool
        let lactoseFree: Bool
        let nutFree: Bool
        let vegetarian: Bool
        let halal: Bool
        
        var formattedRestrictions: NSMutableAttributedString {
            let attributedString = NSMutableAttributedString()
            var commonRestrictions = "None"
            if lactoseFree {
                commonRestrictions = "Lactose Free\n"
            }
            if nutFree {
                commonRestrictions += "Nut Free\n"
            }
            if vegetarian {
                commonRestrictions += "Vegetarian\n"
            }
            if halal {
                commonRestrictions += "Halal\n"
            }
            if glutenFree {
                commonRestrictions += "Gluten Free"
            }
 
            let commonAttributedRestrictions = NSAttributedString(string: commonRestrictions,
                                                                  attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .bold)]
                                                                 )
            attributedString.append(commonAttributedRestrictions)
            
            if let otherRestrictions = other {
                let attributedOther = "\nOther: \(otherRestrictions)"
                attributedString.append(NSAttributedString(string: attributedOther))
            }
            return attributedString
        }
    }

    struct Terms: Codable {
        let privacyPolicy: Bool
        let under18: Bool
        let codeOfConduct: Bool
    }
    
    struct Skills: Codable {
        let challengeStatement: String?
        let accomplishmentStatement: String?
        let selfTitle: String?
        let numHackathons: Int
    }
    
    struct Review: Codable {
        let wave: Int
    }
}

