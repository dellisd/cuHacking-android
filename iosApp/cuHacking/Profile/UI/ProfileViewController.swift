//
//  ProfileViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-10-20.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Firebase

typealias PersonalInfoCell = ImageLabelView
typealias TeamInfoCell = ImageLabelSubtitleView

class ProfileViewController: UIViewController {
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        flowLayout.estimatedItemSize = CGSize(width: view.bounds.width, height: 10)
        return flowLayout
    }
    private var collectionView: UICollectionView!
    private var userProfile: MagnetonAPIObject.UserProfile?
    private let tableView = UITableView()
    private let userInfo: [String] = []
    private let teamInfo: [String] = []
    private let currentUser: User
    private let profileName: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: Fonts.ReemKufi.regular, size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let dataSource: ProfileRepository

    init(dataSource: ProfileRepository = ProfileDataSource(), currentUser: User) {
        self.dataSource = dataSource
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationController()
        qrImageView.image = currentUser.uid.qrCode
        showSpinner()
        currentUser.getIDToken { [weak self] (token, error) in
            guard let self = self else {
                return
            }
            if let token = token {
                self.dataSource.getUserProfile(token: token) { [weak self] (profile, error) in
                    DispatchQueue.main.async {
                        self?.removeSpinner()
                    }
                    if error != nil {
                        print(error)
                    }

                    guard let profile = profile else {
                        print("Failed to get profile")
                        return
                    }
                    self?.userProfile = profile
                    if profile.data.role == "admin" || profile.data.role == "Volunteer" {
                        UserAccess.isAdmin = true
                    }
                    DispatchQueue.main.async {
                        self?.setupNavigationController()
                        self?.collectionView.reloadData()
                        self?.profileName.text = "\(profile.data.application.basicInfo.firstName ?? "")  \(profile.data.application.basicInfo.lastName ?? "")"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.removeSpinner()
                }
            }
        }
    }

    private func setup() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        view.backgroundColor = Asset.Colors.background.color
        collectionView.backgroundColor = Asset.Colors.background.color
        view.addSubviews(views: profileName, qrImageView, collectionView)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileName.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),

            qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            qrImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            qrImageView.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 16),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)

        ])

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(PersonalInfoCell.self, forCellWithReuseIdentifier: "ImageLabelView")
    }

    private func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = Asset.Colors.primaryText.color
        var barButtonItems: [UIBarButtonItem] = []
        //Adding QR Scan icon to button navigation bar IF user is admin
        let settingsIconBar = UIBarButtonItem(image: Asset.Images.settingsIcon.image, style: .plain, target: self, action: #selector(showSettings))
        if let userProfile = userProfile, UserAccess.isAdmin {
             let qrBarItem = UIBarButtonItem(image: Asset.Images.qrIcon.image, style: .plain, target: self, action: #selector(showQRScanner))
            barButtonItems.append(qrBarItem)
        }
        barButtonItems.append(settingsIconBar)
        self.navigationItem.rightBarButtonItems = barButtonItems
    }

    @objc func showQRScanner() {
        let qrScannerViewController = QRScannerViewController(currentUser: currentUser)
        navigationController?.pushViewController(qrScannerViewController, animated: false)
    }

    @objc func showSettings() {
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: false)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let profile = userProfile else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelView", for: indexPath) as? PersonalInfoCell else {
                return UICollectionViewCell()
            }

            cell.update(image: nil, text: nil)
            return cell
        }
        return ProfileBuilder.personalInfoCell(profile: profile, collectionView: collectionView, indexPath: indexPath)

    }
}
