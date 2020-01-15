//
//  SettingsViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    private let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Asset.Colors.purple.color, for: .normal)
        button.setTitle("View privacy policy", for: .normal)
        button.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        return button
    }()

    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Sign Out", for: .normal)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        view.backgroundColor =  Asset.Colors.background.color
        setup()
    }

    func setup() {
        privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubviews(views: privacyPolicyButton, signOutButton)
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            privacyPolicyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            privacyPolicyButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.03),
            
            signOutButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor, constant: 16),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signOutButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.03),
        ])
    }

    func setupNavigationController() {
        self.title = "Settings"
    }

    @objc func showPrivacyPolicy() {
        let privacyPolicyViewController = PrivacyPolicyViewController()
        navigationController?.pushViewController(privacyPolicyViewController, animated: false)
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}
