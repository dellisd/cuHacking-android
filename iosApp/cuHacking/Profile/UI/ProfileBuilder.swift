//
//  ProfileBuilder.swift
//  cuHacking
//
//  Created by Santos on 2020-01-02.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit
enum ProfileBuilder {
    enum Cells: String {
        case personalInfoCell = "ImageLabelView"
    }
    static func personalInfoCell(profile: MagnetonAPIObject.UserProfile, collectionView: UICollectionView, indexPath: IndexPath) -> PersonalInfoCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.personalInfoCell.rawValue, for: indexPath) as? PersonalInfoCell else {
            fatalError("Personal info cell wsa not found.")
        }
        switch indexPath.row {
        case 0:
            cell.image = nil
            cell.imageBackgroundColor = profile.data.badgeColor
            cell.roundImage()
            cell.text = profile.data.color.capitalized
        case 1:
            cell.image = Asset.Images.foodIcon.image
            cell.attributedText = profile.data.application.personalInfo.dietaryRestrictions.formattedRestrictions
        case 2:
            cell.image = Asset.Images.grad.image
            cell.text = profile.data.application.personalInfo.school
        case 3:
            cell.image = Asset.Images.mail.image
            cell.text = profile.data.email
        default:
            fatalError("index path out of range")
        }
        cell.imageTint = Asset.Colors.primaryText.color
        return cell
    }
}
