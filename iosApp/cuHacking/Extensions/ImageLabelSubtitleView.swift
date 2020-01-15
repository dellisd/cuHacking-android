//
//  ImageLabelSubtitleView.swift
//  cuHacking
//
//  Created by Santos on 2019-10-21.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class ImageLabelSubtitleView: UICollectionViewCell {
    private let imageView = UIImageView()
    private var label = UILabel()
    private let subLabel = UILabel()

    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    var subText: String? {
        didSet {
            subLabel.text = subText
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

    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .vertical

        subLabel.font = UIFont.systemFont(ofSize: 12)
        addSubviews(views: imageView, stackView)
        stackView.addArrangedSubviews(views: label, subLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    func update(image: UIImage, text: String, subText: String) {
        self.image = image
        self.text = text
        self.subText = subText
    }
}
