//
//  TimerLabel.swift
//  cuHacking
//
//  Created by Santos on 2019-12-21.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
final class TimerLabel: UICollectionViewCell {
    private var totalTime: TimeInterval = 0
    private var message: String = ""
    private var completedMessage = ""
    private var timer: Timer?
    private var formattedTime: String {
        let hours: Int = Int(totalTime)/3600
        let minutes: Int = Int(totalTime) / 60 % 60
        let seconds = Int(totalTime)%60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private let label: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont(font: Fonts.ReemKufi.regular, size: 26)
        label.textAlignment = .center
        label.textColor = Asset.Colors.title.color
        label.numberOfLines = 0
        return label
    }()

    private lazy var width: NSLayoutConstraint = {
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

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 100))
    }

    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.fillSuperview()
        
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor).isActive = true
        }
    }
    
    func startCountdown(from totalTime: TimeInterval, withMessage message: String = "", completedMessage: String = "") {
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        
        self.totalTime = totalTime
        self.message = message
        self.completedMessage = completedMessage
    }
    
    @objc private func updateLabel() {
        label.text = message + "\n\(formattedTime)"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            label.text = completedMessage
            timer?.invalidate()
        }
    }
}
