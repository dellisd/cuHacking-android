//
//  ScheduleDetailViewController.swift
//  cuHacking
//
//  Created by Santos on 2020-01-08.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit
class ScheduleDetailViewController: UIViewController {
    private let event: MagnetonAPIObject.Event
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = Asset.Colors.primaryText.color
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Asset.Colors.primaryText.color
        return label
    }()
    private let locationView: IconTitleView = {
        let view = IconTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = Asset.Images.mapPinPoint.image
        view.imageView.tintColor = Asset.Colors.primaryText.color
        return view
    }()
    private let eventTypeView: IconTitleView = {
        let view = IconTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let eventDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = nil
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .left
        textView.font = UIFont(font: Fonts.Mplus1p.medium, size: 14)
        return textView
    }()
    init(event: MagnetonAPIObject.Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = event.title
        timeLabel.text = event.formattedDuration
        locationView.titleLabel.text = event.location
        eventTypeView.titleLabel.text = event.type
        eventTypeView.imageView.backgroundColor = event.color
        eventDescription.text = event.description
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        view.backgroundColor = Asset.Colors.background.color
        setup()
        setupNavigationController()
    }
    func setup() {
        let leadSpacing: CGFloat = 16
        view.addSubviews(views: titleLabel, timeLabel, locationView, eventTypeView, eventDescription)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
            titleLabel.heightAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.20),

            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
            timeLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09),

            locationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
            locationView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            locationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
            locationView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),

            eventTypeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
            eventTypeView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 0),
            eventTypeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
            eventTypeView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),

            eventDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
            eventDescription.topAnchor.constraint(equalTo: eventTypeView.bottomAnchor, constant: 10),
            eventDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
            eventDescription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = Asset.Colors.primaryText.color
//        self.navigationController?.navigationBar.topItem?.title = "Event"
    }
}

fileprivate final class IconTitleView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Asset.Colors.primaryText.color
        return label
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        addSubviews(views: imageView, titleLabel)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeRounded()
    }
}
