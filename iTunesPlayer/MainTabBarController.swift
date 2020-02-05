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
    
    // MARK: - Live cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - metods
    
    private func setup() {
        let searchVC = SearchViewController()
        searchVC.tabBarDelegate = self
        let searchNC = UINavigationController(rootViewController: searchVC)
        searchNC.navigationBar.topItem?.title = "Search"
        searchNC.navigationBar.prefersLargeTitles = true
        searchNC.tabBarItem.title = "Search"
        searchNC.tabBarItem.image = UIImage(systemName: "doc.text.magnifyingglass")
        
        let libraryVC = LibraryViewController()
        libraryVC.tabBarItem.title = "Library"
        libraryVC.tabBarItem.image = UIImage(systemName: "doc.plaintext")
        
        viewControllers = [searchNC, libraryVC]
        
        tabBar.tintColor = .red
//        tabBar.barTintColor = .yellow
        
//        view.addSubview(trackPlayerView)
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
    
    func panGesturePlayer(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: break
        case .changed: panGestureChanged(gesture: gesture)
        case .ended: panGestureEnd(gesture: gesture)
        case .possible: break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
    }
    
    private func panGestureChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let screenHeight = UIScreen.main.bounds.size.height
        let tabbarHeight = tabBar.bounds.height
        let newY = screenHeight - tabbarHeight - 60 + translation.y
        trackPlayerView.frame.origin.y = newY
        
        let newAlpha = 1 + translation.y / 200
        trackPlayerView.miniStackView.alpha = newAlpha < 0 ? 0 : newAlpha
        trackPlayerView.mainStackView.alpha = -translation.y / 200
    }
    
    private func panGestureEnd(gesture: UIPanGestureRecognizer) {
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
}
