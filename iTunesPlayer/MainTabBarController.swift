//
//  MainTabBarController.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.navigationBar.topItem?.title = "Search"
        searchVC.navigationBar.prefersLargeTitles = true
        searchVC.tabBarItem.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "doc.text.magnifyingglass")
        
        let libraryVC = TrackPlayViewController()
        libraryVC.tabBarItem.title = "Library"
        libraryVC.tabBarItem.image = UIImage(systemName: "doc.plaintext")
        
        viewControllers = [searchVC, libraryVC]
        
        tabBar.tintColor = .red
//        tabBar.barTintColor = .yellow
    }
    
}
