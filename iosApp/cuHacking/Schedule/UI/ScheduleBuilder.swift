//
//  ScheduleBuilder.swift
//  cuHacking
//
//  Created by Santos on 2019-12-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//
import UIKit

enum ScheduleViewBuilder {
    static let colors: [UIColor] = [
        Asset.Colors.purpleEvent.color,
        Asset.Colors.blueEvent.color,
        Asset.Colors.redEvent.color,
        Asset.Colors.greenEvent.color
    ]
    enum Cells: String {
        case eventCell = "EventCell"
    }
    static func eventCell(days: [Day], collectionView: UICollectionView, indexPath: IndexPath) -> EventCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.eventCell.rawValue, for: indexPath) as? EventCollectionViewCell else {
            fatalError("Could not find event cell")
        }
        let event = days[indexPath.section].events[indexPath.row]
        cell.eventDetailsView.backgroundColor = event.color
        cell.eventTimeLabel.text = event.formattedStartTime
        cell.eventDetailsView.informationTextView.isUserInteractionEnabled = false
        cell.eventDetailsView.update(title: event.title,
                                     information: event.formattedDuration,
                                     buttonTitle: event.location,
                                     buttonIcon: Asset.Images.mapPinPoint.image)
        return cell
    }
}
