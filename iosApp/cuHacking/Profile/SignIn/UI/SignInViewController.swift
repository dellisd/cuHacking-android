//
//  SignInViewController.swift
//  cuHacking
//
//  Created by Santos on 2020-01-02.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    enum TextFieldTag: Int {
        case email = 0
        case password = 1
    }
    private var errorLabelBottomConstraint: NSLayoutConstraint!
    private var keyboardIsVisible = false

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.Images.cuHackingLogo.image
        return imageView
    }()

    private let emailField: UITextFieldPadding = {
        let textField = UITextFieldPadding()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email"
        textField.layer.borderColor = Asset.Colors.primaryText.color.cgColor
        textField.layer.borderWidth = 1.0
        textField.tag = TextFieldTag.email.rawValue
        return textField
    }()

    private let passwordField: UITextFieldPadding = {
        let textField = UITextFieldPadding()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.layer.borderColor = Asset.Colors.primaryText.color.cgColor
        textField.layer.borderWidth = 1.0
        textField.tag = TextFieldTag.password.rawValue
        return textField
    }()

    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = Asset.Colors.purple.color
        button.dropShadow()
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.background.color
        setup()
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }

    private func setup() {
        emailField.delegate = self
        passwordField.delegate = self

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubviews(views: logoImageView, emailField, passwordField, signInButton, errorLabel)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40),
            logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40),

            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.10),
            signInButton.topAnchor.constraint(equalTo: passwordField.topAnchor, constant: 80),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    @objc private func signIn() {
        showSpinner()
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        errorLabel.text = ""
        let email = emailField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let password = passwordField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (auth, error) in
            guard let self = self else {
                return
            }
            self.removeSpinner()
            if error != nil {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error?.localizedDescription ?? ""
            } else if let auth = auth {
                self.errorLabel.isHidden = true
                let profileViewController = ProfileViewController(currentUser: auth.user)
                var relevantViewControllers = self.navigationController!.viewControllers
                relevantViewControllers[relevantViewControllers.count-1] = profileViewController

                self.navigationController?.setViewControllers(relevantViewControllers, animated: true)
            }
        }
    }
    
    //Handles the sliding of the keyboard of the
    @objc func keyboardWillChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        if notification.name == UIResponder.keyboardWillShowNotification ||
        notification.name == UIResponder.keyboardWillChangeFrameNotification {
            if keyboardIsVisible == false {
                UIView.animate(withDuration: 0.2) {
                    self.view.frame.origin.y = keyboardRect.origin.y - self.errorLabel.frame.origin.y
                }
            }
        } else {
            view.frame.origin.y = 0
            keyboardIsVisible = false
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        emailField.layer.borderColor = Asset.Colors.primaryText.color.cgColor
        passwordField.layer.borderColor = Asset.Colors.primaryText.color.cgColor
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == TextFieldTag.email.rawValue {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            keyboardIsVisible = false
        } else {
            textField.resignFirstResponder()
        }
        errorLabel.text = ""
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardIsVisible = true
    }
}
