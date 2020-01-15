//
//  UIViewController+Ext.swift
//  cuHacking
//
//  Created by Santos on 2020-01-07.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit
fileprivate var spinnerBackgroundView: UIView?

extension UIViewController {
    //This method shows a spinner icon which can be used when loading.
    func showSpinner() {
        removeSpinner()
        view.isUserInteractionEnabled = false
        spinnerBackgroundView = UIView()
        guard let spinnerBackgroundView = spinnerBackgroundView else {
            return
        }
        spinnerBackgroundView.backgroundColor = Asset.Colors.background.color.withAlphaComponent(0.7)
        spinnerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        spinnerBackgroundView.layer.cornerRadius = 16
        var loadingIndicator: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            loadingIndicator = UIActivityIndicatorView(style: .large)
        } else {
            loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
        }
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        spinnerBackgroundView.addSubview(loadingIndicator)
        view.addSubview(spinnerBackgroundView)
        NSLayoutConstraint.activate([
            spinnerBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinnerBackgroundView.widthAnchor.constraint(equalToConstant: 100),
            spinnerBackgroundView.heightAnchor.constraint(equalTo: spinnerBackgroundView.widthAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: spinnerBackgroundView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: spinnerBackgroundView.centerYAnchor)
        ])
        loadingIndicator.startAnimating()
    }
    //This removes the spinner, if it exists.
    func removeSpinner() {
        spinnerBackgroundView?.removeFromSuperview()
        spinnerBackgroundView = nil
        view.isUserInteractionEnabled = true
    }
}
