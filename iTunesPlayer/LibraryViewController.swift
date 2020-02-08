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
    private var dataProvider: DataProvider!
    private var storeManager: StoreManager!
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(TrackTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storeManager.loadStoreTracks()
        table.reloadData()
    }
    
    //MARK: - Metods
    
    private func setup() {
        presenter = LibraryPresenter(libraryView: self)
        dataProvider = DataProvider()
        interactor = LibraryInteractor(presenter: presenter, dataProvider: dataProvider)
        storeManager = StoreManager()
    }
    
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
        return storeManager.storeTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackTableViewCell
        cell.delegate = self
        let storeTrack = storeManager.storeTracks[indexPath.row]
        let track = Track(artistName: storeTrack.artistName,
                          trackName: storeTrack.trackName,
                          artworkUrl60: storeTrack.artworkUrl60,
                          previewUrl: storeTrack.previewUrl)
        cell.set(track: track, hiddenPlus: true)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: - TrackTableViewCellProtocol

extension LibraryViewController: TrackTableViewCellProtocol {
    
    func pressPlusButton(button: UIButton) {
        
    }
    
    func getImage(from urlString: String?, complete: @escaping ((UIImage?) -> Void)) {
        interactor.getImageData(from: urlString, complete: complete)
    }
    
}
