//
//  TitleImageView.swift
//  cuHacking
//
//  Created by Santos on 2019-11-03.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit

class TitleImageView: UICollectionReusableView {
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(font: Fonts.ReemKufi.regular, size: 18)
        label.textColor = Asset.Colors.primaryText.color
        return label
    }()

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubviews(views: titleLabel, imageView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),

            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0)
        ])
    }

    func update(title: String?, image: UIImage?) {
        self.title = title
        self.image = image
    }
}
