////
////  ImageLabelCell.swift
////  cuHacking
////
////  Created by Santos on 2019-10-20.
////  Copyright © 2019 cuHacking. All rights reserved.
////
//
import UIKit
class ImageLabelView: UICollectionViewCell {
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    var imageTint: UIColor? {
        didSet {
            imageView.tintColor = imageTint
        }
    }
    var attributedText: NSMutableAttributedString? {
        
        didSet {
            label.attributedText = attributedText
        }
    }
    var imageBackgroundColor: UIColor? {
        didSet {
            imageView.backgroundColor = imageBackgroundColor
        }
    }
    var text: String? {
        didSet {
            label.text = text
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
        contentView.addSubviews(views: imageView, label)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.topAnchor)
        ])
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor).isActive = true
        }
    }

    func update(image: UIImage?, text: String?) {
        self.image = image
        self.text = text
    }

    func roundImage() {
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
