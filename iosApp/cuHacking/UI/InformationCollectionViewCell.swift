//
//  InformationCollectionViewCell.swift
//  cuHacking
//
//  Created by Santos on 2019-11-23.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class InformationCollectionViewCell: UICollectionViewCell {
    public let informationView: InformationView = {
        let infoView = InformationView()
        infoView.backgroundColor = Asset.Colors.secondarySurface.color
        return infoView
    }()

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

    func setup() {
        let padding: CGFloat = 10
        contentView.addSubview(informationView)
        NSLayoutConstraint.activate([
            informationView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            informationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            informationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            informationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding)
        ])

        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor).isActive = true
        }
    }
}
