//
//  InformationBuilder.swift
//  cuHacking
//
//  Created by Santos on 2019-12-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
enum InformationBuilder {
    enum Cells: String {
        case informationCell = "InfoCell"
    }

    enum Info {
        static func infoCell(information: MagnetonAPIObject.Information, collectionView: UICollectionView, indexPath: IndexPath) -> InformationCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.informationCell.rawValue, for: indexPath) as? InformationCell else {
                fatalError("InformationCell was not found.")
            }
            switch indexPath.row {
            case 0: //Wifi
                let text = "Network:\(information.wifi.network)\nPassword:\(information.wifi.password)"
                cell.informationView.update(title: "Wifi Info", information: text)
                break
            case 1: //Emergency
                cell.informationView.update(title: "Emergency", information: information.emergency)
            case 2: //Help
                cell.informationView.update(title: "Help", information: information.help)
            case 3: //Social
                let html =
                """
                <a style="font-size: 16px" href="\(information.social.twitter)">Twitter</a><br/><br/>
                <a style="font-size: 16px" href="\(information.social.facebook)">Facebook</a><br /><br/>
                <a style="font-size: 16px" href="\(information.social.instagram)">Instagram</a><br/><br/>
                <a style="font-size: 16px" href="\(information.social.slack)">Slack</a>
                """
                let htmlData = Data(html.utf8)
                if let attributedString = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    cell.informationView.update(title: "Social", attributedInformation: attributedString)
                }
                break
            default:
                cell.informationView.update(title: nil, information: nil, buttonTitle: nil, buttonIcon: nil)
            }
            cell.informationView.titleLabel.textColor = .black
            cell.informationView.informationTextView.textColor = .black
            return cell
        }
    }
}
