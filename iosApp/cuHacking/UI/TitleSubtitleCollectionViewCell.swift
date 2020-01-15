//
//  TitleSubtitleCollectionViewCell.swift
//  cuHacking
//
//  Created by Santos on 2019-11-23.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class TitleSubtitleCollectionViewCell: UICollectionViewCell {
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: Fonts.ReemKufi.regular, size: 26)
        label.textAlignment = .center
        label.textColor = Asset.Colors.title.color
        return label
    }()

    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: Fonts.ReemKufi.regular, size: 26)
        label.textAlignment = .center
        label.textColor = Asset.Colors.title.color
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let verticalStack = UIStackView()
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.addArrangedSubviews(views: titleLabel, subtitleLabel)
        verticalStack.spacing = 4
        verticalStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        verticalStack.isLayoutMarginsRelativeArrangement = true

        contentView.addSubview(verticalStack)
        verticalStack.fillSuperview()

        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor).isActive = true
        }
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
