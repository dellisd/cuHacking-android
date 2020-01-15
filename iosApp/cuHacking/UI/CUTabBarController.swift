//
//  CUTabBarController.swift
//  cuHacking
//
//  This is the central tab bar seen throughout the applications.
//
//  Created by Santos on 2019-06-27.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class CUTabBarController: UITabBarController {
    override func viewDidLoad() {
        // First tab - Home
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.tintColor =  Asset.Colors.gray.color
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: Asset.Images.homeIcon.image, tag: 0)

        // Second tab - Information VC
        let informationViewController = InformationViewController()
        informationViewController.tabBarItem = UITabBarItem(title: "Info", image: Asset.Images.info.image, tag: 1)

        //Third tab - Schedule VC
        let scheduleViewController = ScheduleViewController()
        let scheduleNavigationController = UINavigationController(rootViewController: scheduleViewController)
        scheduleNavigationController.tabBarItem = UITabBarItem(title: "Schedule", image: Asset.Images.scheduleIcon.image, tag: 2)

//        Fourth tab - Map vc
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: Asset.Images.mapIcon.image, tag: 3)

        //Setting view controllers
        viewControllers = [navigationController,
                           informationViewController,
                           scheduleNavigationController,
                            mapViewController]
        tabBar.tintColor =  Asset.Colors.purple.color
        tabBar.unselectedItemTintColor =  Asset.Colors.gray.color
    }
}
