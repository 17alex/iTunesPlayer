//
//  LibraryViewController.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {

    // MARK: - Property
    private var presenter: LibraryPresenter!
    private var interactor: LibraryInteractor!
    
    weak var tabBarDelegate: MainTabBarController?
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(TrackTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: - Init
    
    convenience init(dataProvider: DataProvider, storeManager: StoreManager) {
        self.init()
        
        presenter = LibraryPresenter(libraryView: self)
        interactor = LibraryInteractor(presenter: presenter, dataProvider: dataProvider, storeManager: storeManager)
    }
    
    // MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadStoreTracks()
        table.reloadData()
        tabBarDelegate?.trackPlayerView.delegate = self
    }
    
    //MARK: - Metods

    private func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(table)
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    

}

// MARK: - UITableViewDataSource

extension LibraryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getStoreTracksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackTableViewCell
        cell.delegate = self
        let track = interactor.getTrackFromStore(for: indexPath.row)
        cell.set(track: track, hiddenPlus: true)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = interactor.getTrackFromStore(for: indexPath.row)
        tabBarDelegate?.maximizeTrackPlayerView(track: track)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextualAction, view, boolValue) in
            self?.interactor.deleteTrackFromStore(for: indexPath.row)
            self?.table.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
}

// MARK: - TrackTableViewCellProtocol

extension LibraryViewController: TrackTableViewCellProtocol, TrackPlayerProtocol {
    
    func minimizePlayerPanGesture(gesture: UIPanGestureRecognizer) {
        tabBarDelegate?.minimizePanGesturePlayer(gesture: gesture)
    }
    
    func maximizePlayerPanGesture(gesture: UIPanGestureRecognizer) {
        tabBarDelegate?.maximizePanGesturePlayer(gesture: gesture)
    }
    
    func maximizePlayer() {
        tabBarDelegate?.maximizeTrackPlayerView(track: nil)
    }
    
    func minimizePlayer() {
        tabBarDelegate?.minimizeTrackPlayerView()
    }
    
    func getTrack(for direction: DirectionPlay) -> Track? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil}
        table.deselectRow(at: indexPath, animated: true)
        var forIndexPath = indexPath
        switch direction {
        case .backward: forIndexPath.row = indexPath.row == 0 ?
            interactor.getStoreTracksCount() - 1 : indexPath.row - 1
        case .forward: forIndexPath.row = indexPath.row == interactor.getStoreTracksCount() - 1 ? 0 : indexPath.row + 1
        }
        table.selectRow(at: forIndexPath, animated: true, scrollPosition: .middle)
        let track = interactor.getTrackFromStore(for: indexPath.row)
        return track
    }
    
    func pressPlusButton(button: UIButton) {
        
    }
    
    func getImage(from urlString: String?, complete: @escaping ((UIImage?) -> Void)) {
        interactor.getImageData(from: urlString, complete: complete)
    }
    
}
