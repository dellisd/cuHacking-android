//
//  EventCollectionViewCell.swift
//  cuHacking
//
//  Created by Santos on 2019-12-02.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class EventCollectionViewCell: UICollectionViewCell {
    let eventDetailsView: InformationView = {
        let infoView = InformationView()
        infoView.titleLabel.textColor = Asset.Colors.secondayText.color
        infoView.titleLabel.font = UIFont(font: Fonts.Roboto.regular, size: 25)
        infoView.informationTextView.textColor = Asset.Colors.subtitle.color
        infoView.informationTextView.font = UIFont(font: Fonts.Roboto.regular, size: 18)
        infoView.styleButton(textColor: Asset.Colors.secondayText.color)
        return infoView
    }()
    let eventTimeLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let padding: CGFloat = 10.0
        contentView.addSubviews(views: eventTimeLabel, eventDetailsView)
        eventTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            eventTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventTimeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eventTimeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),

            eventDetailsView.leadingAnchor.constraint(equalTo: eventTimeLabel.trailingAnchor),
            eventDetailsView.topAnchor.constraint(equalTo: eventTimeLabel.topAnchor),
            eventDetailsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            eventDetailsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor).isActive = true
        }
    }
}
