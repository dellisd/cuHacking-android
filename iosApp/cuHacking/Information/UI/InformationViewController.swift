//
//  InformationViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-27.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics
import NetworkExtension

typealias InformationCell = InformationCollectionViewCell

class InformationViewController: CUCollectionViewController {
    private var information: MagnetonAPIObject.Information?
    private let dataSource: InformationRepository

    init(dataSource: InformationRepository = InformationDataSource()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInformation()
        refreshController.removeFromSuperview()
    }

    override func registerCells() {
        super.registerCells()
        collectionView.register(InformationCell.self, forCellWithReuseIdentifier: InformationBuilder.Cells.informationCell.rawValue)
    }

    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.dataSource = self
    }

    override func refreshData() {
    }

    func loadInformation() {
        dataSource.getInformation { [weak self] (informationResult, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            }
            guard let information = informationResult?.info else {
                print("Failed to get information")
                return
            }
            self?.information = information
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
//  This method was not used because it was undetermined if the method works when the SSID contains spaces. 
//    @objc func connectToWifi() {
//        let hotSpotConfig = NEHotspotConfiguration(ssid: "HOME", passphrase: "cuhacking", isWEP: false)
//        NEHotspotConfigurationManager.shared.apply(hotSpotConfig) { (error) in
//            if let error = error {
//                print("failed:\(error)")
//            } else {
//                print("success")
//            }
//        }
//    }
}

extension InformationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return information?.amountOfInformation ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let information = information else {
            fatalError("No information")
        }
        return InformationBuilder.Info.infoCell(information: information, collectionView: collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader

        guard let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView else {
            fatalError("Title image view not found")
        }

        if kind == headerKind {
            titleImageView.update(title: "Information", image: nil)
        } else { titleImageView.update(title: nil, image: nil) }

        return titleImageView
    }
}
