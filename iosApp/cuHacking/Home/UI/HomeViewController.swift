//
//  HomeViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-12-14.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import FirebaseAuth

typealias HeaderCell = TimerLabel
typealias OnboardingCell = InformationCollectionViewCell
typealias UpdateCell = InformationCollectionViewCell

class HomeViewController: CUCollectionViewController {
    private var updates: [MagnetonAPIObject.Update]?
    private var dataSource: HomeRepository

    init(dataSource: HomeRepository = HomeDataSource()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        loadUpdates()
    }

    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.dataSource = self
    }

    override func registerCells() {
        super.registerCells()
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: HomeBuilder.Cells.onboardingCell.rawValue)
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HomeBuilder.Cells.headerCell.rawValue)
        collectionView.register(UpdateCell.self, forCellWithReuseIdentifier: HomeBuilder.Cells.updateCell.rawValue)
    }

    private func setupNavigationController() {
        self.navigationController?.navigationBar.topItem?.title = "cuHacking"
        self.navigationController?.navigationBar.tintColor = Asset.Colors.primaryText.color
        //Adding profile icon button to navigation bar
        let profileIconButton = UIBarButtonItem(image: Asset.Images.profileIcon.image, style: .plain, target: self, action: #selector(showProfile))
        self.navigationItem.rightBarButtonItem = profileIconButton
    }
    
    override func refreshData() {
        super.refreshData()
        loadUpdates()
    }

    private func loadUpdates() {
        HomeDataSource().getUpdates { [weak self] (updates, error) in
            DispatchQueue.main.async {
               if self?.refreshController.isRefreshing == true {
                   self?.refreshController.endRefreshing()
               }
            }
            if error != nil {
                print(error)
                return
            }
            guard let updates = updates else {
                print("Failed to get updates")
                return
            }
            self?.updates = updates.relevantUpdates
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    @objc func showSettings() {
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: false)
    }

    @objc func showProfile() {
        var desinationVC: UIViewController!
        if let user = Auth.auth().currentUser {
            desinationVC = ProfileViewController(currentUser: user)
        } else {
            desinationVC = SignInViewController()
        }
        self.navigationController?.pushViewController(desinationVC, animated: false)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return updates?.count ?? 0
        default:
            fatalError("Too many sections")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: // Header Section
            switch indexPath.row {
            case 0:
                return HomeBuilder.Header.headerCell(collectionView: collectionView, indexPath: indexPath)
            case 1:
                return HomeBuilder.Header.onbaordingCell(collectionView: collectionView, indexPath: indexPath)
            default:
                fatalError("Row out of range")
            }
        case 1: //Announcments section
            guard let updates = updates else {
                fatalError("Asking for updates when none exist.")
            }
            return HomeBuilder.Announcements.updateCell(updates: updates, collectionView: collectionView, indexPath: indexPath)
        default:
            fatalError("Section out of range")
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader

        if kind == headerKind,
            let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView {
            switch indexPath.section {
            case 1:
                titleImageView.update(title: "Announcements", image: nil)
                return titleImageView
            default:
                break
            }
        }
        guard let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView else {
            fatalError("Title image view not found")
        }
        titleImageView.update(title: nil, image: nil)
        return titleImageView
    }
}
