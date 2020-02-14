//
//  MainTabBarController.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Propertis
    
    let trackPlayerView = TrackPlayerView()
    let dataProvider = DataProvider()
    let storeManager = StoreManager()
    
    // MARK: - Live cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - metods
    
    private func setup() {
        let searchVC = SearchViewController(dataProvider: dataProvider, storeManager: storeManager)
        searchVC.tabBarDelegate = self
        
        let searchNC = UINavigationController(rootViewController: searchVC)
        searchNC.navigationBar.topItem?.title = "Search"
        searchNC.navigationBar.prefersLargeTitles = true
        searchNC.tabBarItem.title = "Search"
        searchNC.tabBarItem.image = UIImage(systemName: "doc.text.magnifyingglass")
        
        let libraryVC = LibraryViewController(dataProvider: dataProvider, storeManager: storeManager)
        libraryVC.tabBarDelegate = self
        
        let libraryNC = UINavigationController(rootViewController: libraryVC)
        libraryNC.navigationBar.topItem?.title = "Library"
        libraryNC.navigationBar.prefersLargeTitles = true
        libraryNC.tabBarItem.title = "Library"
        libraryNC.tabBarItem.image = UIImage(systemName: "doc.plaintext")
        
        viewControllers = [searchNC, libraryNC]
        
        tabBar.tintColor = .red
        
        view.insertSubview(trackPlayerView, belowSubview: tabBar)
        trackPlayerView.delegate = searchVC
        var frame = UIScreen.main.bounds
        frame.origin.y = frame.size.height
        trackPlayerView.frame = frame
    }
}

// MARK: - Extensions

extension MainTabBarController {
    
    func maximizeTrackPlayerView(track: Track?) {
        let frame = UIScreen.main.bounds
        if let track = track { trackPlayerView.set(track: track) }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.trackPlayerView.frame = frame
            self?.trackPlayerView.mainStackView.alpha = 1
            self?.trackPlayerView.miniStackView.alpha = 0
            let yOffset = self?.tabBar.bounds.height
            self?.tabBar.transform = CGAffineTransform(translationX: 0, y: yOffset ?? 0)
        }, completion: nil)
    }
    
    func minimizeTrackPlayerView() {
        var frame = UIScreen.main.bounds
        frame.origin.y = frame.size.height - tabBar.bounds.height - 60
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.trackPlayerView.frame = frame
            self?.trackPlayerView.mainStackView.alpha = 0
            self?.trackPlayerView.miniStackView.alpha = 1
            self?.tabBar.transform = .identity
        }, completion: nil)
        
    }
    
    func maximizePanGesturePlayer(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: break
        case .changed: maximizePanGestureChanged(gesture: gesture)
        case .ended: maximizePanGestureEnd(gesture: gesture)
        case .possible: break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
    }
    
    private func maximizePanGestureChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let screenHeight = UIScreen.main.bounds.size.height
        let tabbarHeight = tabBar.bounds.height
        let newY = screenHeight - tabbarHeight - 60 + translation.y
        trackPlayerView.frame.origin.y = newY
        
        let newAlpha = 1 + translation.y / 200
        trackPlayerView.miniStackView.alpha = newAlpha < 0 ? 0 : newAlpha
        trackPlayerView.mainStackView.alpha = -translation.y / 200
    }
    
    private func maximizePanGestureEnd(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let velocity = gesture.velocity(in: self.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            if translation.y < -200 || velocity.y < -500 {
                self.maximizeTrackPlayerView(track: nil)
            } else {
                self.minimizeTrackPlayerView()
            }
        }, completion: nil)
    }
    
    func minimizePanGesturePlayer(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: break
        case .changed: minimizePanGestureChanged(gesture: gesture)
        case .ended: minimizePanGestureEnd(gesture: gesture)
        case .possible: break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
    }
    
    private func minimizePanGestureChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        trackPlayerView.frame.origin.y = translation.y
    }
    
    private func minimizePanGestureEnd(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let velocity = gesture.velocity(in: self.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            if translation.y > 200 || velocity.y > 500 {
                self.minimizeTrackPlayerView()
            } else {
                self.maximizeTrackPlayerView(track: nil)
            }
        }, completion: nil)
    }
}
