//
//  InformationView.swift
//  cuHacking
//
//  Created by Santos on 2019-11-24.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class InformationView: UIView {
    private static let visisbleButtonTopAnchorConstant: CGFloat = 10
    private static let invisisbleButtonTopAnchorConstant: CGFloat = -20
    private var buttonLeadingAnchor: NSLayoutConstraint!
    private var buttonCenterXAnchor: NSLayoutConstraint!
    private var buttonTopAnchor: NSLayoutConstraint!
    var isCentered: Bool = false {
        didSet {
            if isCentered == true {
                titleLabel.textAlignment = .center
                informationTextView.textAlignment = .center
                buttonLeadingAnchor.isActive = false
                buttonCenterXAnchor.isActive = true
            } else {
                titleLabel.textAlignment = .left
                informationTextView.textAlignment = .left
                buttonLeadingAnchor.isActive = true
                buttonCenterXAnchor.isActive = false
            }
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(font: Fonts.ReemKufi.regular, size: 17)
        label.textColor = Asset.Colors.primaryText.color
        return label
    }()

    let informationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = nil
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .left
        textView.font = UIFont(font: Fonts.Mplus1p.medium, size: 12)
        return textView
    }()

    let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(font: Fonts.Mplus1p.medium, size: 12)
        button.setTitleColor(Asset.Colors.purple.color, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let verticalStack = UIStackView()
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        verticalStack.isLayoutMarginsRelativeArrangement = true

        verticalStack.addArrangedSubviews(views: titleLabel, informationTextView)
        addSubview(verticalStack)
        addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        buttonLeadingAnchor = button.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 20)
        buttonCenterXAnchor = button.centerXAnchor.constraint(equalTo: centerXAnchor)
        buttonTopAnchor = button.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 10)

        buttonTopAnchor.isActive = true
        buttonLeadingAnchor.isActive = true

        if let lastSubview = subviews.last {
            bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 10).isActive = true
        }
    }

    func styleButton(textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        if let textColor = textColor {
            button.setTitleColor(textColor, for: .normal)
            button.setTitleColor(textColor, for: .selected)
        }
        if let backgroundColor = backgroundColor {
            button.backgroundColor = backgroundColor
        }
    }

    func update(title: String? = nil, information: String? = nil, buttonTitle: String? = nil, buttonIcon: UIImage? = nil) {
        titleLabel.text = title
        informationTextView.text = information
        if let buttonTitle = buttonTitle {
            if let buttonIcon = buttonIcon {
                button.tintColor = Asset.Colors.background.color
                button.setImage(buttonIcon, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            }
            button.setTitle(buttonTitle, for: .normal)
            buttonTopAnchor.constant = InformationView.visisbleButtonTopAnchorConstant
        } else {
            button.setTitle(nil, for: .normal)
            buttonTopAnchor.constant = InformationView.invisisbleButtonTopAnchorConstant
        }
    }

    func addTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: #selector(ok), for: event)
    }
    @objc func ok() {
        
    }
}
