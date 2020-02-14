//
//  SearchViewController.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Property
    private var presenter: SearchPresenter!
    private var interactor: SearchInteractor!
    
    private var timer: Timer?
    
    weak var tabBarDelegate: MainTabBarController?
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(TrackTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    // MARK: - Init
    
    convenience init(dataProvider: DataProvider, storeManager: StoreManager) {
        self.init()
        
        presenter = SearchPresenter(searchView: self)
        interactor = SearchInteractor(presenter: presenter, dataProvider: dataProvider, storeManager: storeManager)
    }
    
    // MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        interactor.loadStoreTracks()
        searchBar(searchController.searchBar, textDidChange: "gayazov")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarDelegate?.trackPlayerView.delegate = self
    }
    
    //MARK: - Metods
    
    private func setupViews() {
        
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        view.addSubview(table)
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func set(tracks: [Track]?) {
        self.tracks = tracks ?? []
        table.reloadData()
    }
    
    func presentAlert(with text: String) {
        showAlert(with: text)
    }
    
}

enum DirectionPlay {
    case forward
    case backward
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackTableViewCell
        cell.delegate = self
        let track = tracks[indexPath.row]
        let hidden = storeManager.containsTrack(track: track)
        cell.set(track: track, hiddenPlus: hidden)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        tabBarDelegate?.maximizeTrackPlayerView(track: track)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { (_) in
            guard !searchText.isEmpty else { return }
            self.interactor.getData(width: searchText)
        })
    }
    
}

// MARK: - TrackTableViewCellProtocol

extension SearchViewController: TrackTableViewCellProtocol, TrackPlayerProtocol {
    
    func minimizePlayer() {
        tabBarDelegate?.minimizeTrackPlayerView()
    }
    
    func maximizePlayer() {
        tabBarDelegate?.maximizeTrackPlayerView(track: nil)
    }

    func maximizePlayerPanGesture(gesture: UIPanGestureRecognizer) {
        tabBarDelegate?.maximizePanGesturePlayer(gesture: gesture)
    }
    
    func minimizePlayerPanGesture(gesture: UIPanGestureRecognizer) {
        tabBarDelegate?.minimizePanGesturePlayer(gesture: gesture)
    }
    
    func getImage(from urlString: String?, complete: @escaping ((UIImage?) -> Void)) {
        interactor.getImageData(from: urlString, complete: complete)
    }
    
    func pressPlusButton(button: UIButton) {
        guard let cell = button.superview as? TrackTableViewCell,
            let index = table.indexPath(for: cell) else { return }
        storeManager.addTrackToStore(track: tracks[index.row])
        print("storeManager.addTrackToStore indexPath = \(index)")
    }
    
    func getTrack(for direction: DirectionPlay) ->  Track? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil}
        table.deselectRow(at: indexPath, animated: true)
        var forIndexPath = indexPath
        switch direction {
        case .backward: forIndexPath.row = indexPath.row == 0 ? tracks.count - 1 : indexPath.row - 1
        case .forward: forIndexPath.row = indexPath.row == tracks.count - 1 ? 0 : indexPath.row + 1
        }
        table.selectRow(at: forIndexPath, animated: true, scrollPosition: .middle)
        return tracks[forIndexPath.row]
    }
}
