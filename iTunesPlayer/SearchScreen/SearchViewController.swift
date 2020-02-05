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
    private var dataProvider: DataProvider!
    
    private var timer: Timer?
    private var tracks: [Track] = []
    
    weak var tabBarDelegate: MainTabBarController?

    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    // MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupViews()
        searchBar(searchController.searchBar, textDidChange: "gayazov")
    }
    
    //MARK: - Metods
    
    private func setup() {
        presenter = SearchPresenter(searchView: self)
        dataProvider = DataProvider()
        interactor = SearchInteractor(presenter: presenter, dataProvider: dataProvider)
    }
    
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

    func getImage(from urlString: String?, complete: @escaping ((UIImage?) -> Void)) {
        interactor.getImageData(from: urlString, complete: complete)
    }
    
    func minimizePlayer() {
        tabBarDelegate?.minimizeTrackPlayerView()
    }
    
    func maximizePlayer() {
        tabBarDelegate?.maximizeTrackPlayerView(track: nil)
    }
    
    func panGesturePlayer(gesture: UIPanGestureRecognizer) {
        tabBarDelegate?.panGesturePlayer(gesture: gesture)
    }
    
}

enum DirectionPlay {
    case forward
    case backward
}

extension SearchViewController {
    
    func getTrack(for direction: DirectionPlay) ->  Track? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil}
        table.deselectRow(at: indexPath, animated: true)
        var forIndexPath = indexPath
        switch direction {
        case .backward:
            print("backward")
            forIndexPath.row = indexPath.row == 0 ? tracks.count - 1 : indexPath.row - 1
        case .forward:
            print("forward")
            forIndexPath.row = indexPath.row == tracks.count - 1 ? 0 : indexPath.row + 1
        }
        table.selectRow(at: forIndexPath, animated: true, scrollPosition: .middle)
        return tracks[forIndexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.delegate = self
        cell.set(track: tracks[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        tabBarDelegate?.maximizeTrackPlayerView(track: track)
//          keyWindow.addSubview(trackPlayerView)
//        keyWindow.insertSubview(trackPlayerView, belowSubview: tabBarDelegate!.tabBar)
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


