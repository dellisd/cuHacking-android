//
//  ScheduleViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit

class ScheduleViewController: CUCollectionViewController {
    var days: [Day]?
    private let dataSource: ScheduleRepository

    init(dataSource: ScheduleRepository = ScheduleDataSource()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        loadEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func registerCells() {
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleViewBuilder.Cells.eventCell.rawValue)
         collectionView.register(TitleImageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleImageView")
    }

    private func loadEvents() {
        dataSource.getEvents { [weak self] (events, error) in
            DispatchQueue.main.async {
               if self?.refreshController.isRefreshing == true {
                   self?.refreshController.endRefreshing()
               }
            }
            if error != nil {
                print(error)
                return
            }
            guard let events = events else {
                print("Failed to get events")
                return
            }
            self?.days = events.orderedEvents
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func refreshData() {
        refreshController.beginRefreshing()
        loadEvents()
    }
}

extension ScheduleViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        days?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days?[section].events.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let days = days else {
            fatalError("No events")
        }
        return ScheduleViewBuilder.eventCell(days: days, collectionView: collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader

        if kind == headerKind,
            let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView {
            titleImageView.update(title: days?[indexPath.section].name, image: nil)
            return titleImageView
        }
        guard let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView else {
            fatalError("Title image view not found")
        }
        titleImageView.update(title: nil, image: nil)
        return titleImageView
    }
}

extension ScheduleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let days = days else {
            return
        }
        let event = days[indexPath.section].events[indexPath.row]
        let eventDetailsViewController = ScheduleDetailViewController(event: event)
        navigationController?.pushViewController(eventDetailsViewController, animated: false)
    }
}
