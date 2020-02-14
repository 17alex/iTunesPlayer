//
//  LibraryInteractor.swift
//  iTunesPlayer
//
//  Created by Alex on 07.02.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class LibraryInteractor {
    
    // MARK: - Propertis
    
    private unowned let presenter: LibraryPresenter
    unowned let dataProvider: DataProvider
    unowned let storeManager: StoreManager
    
    // MARK: - Init
    
    init(presenter: LibraryPresenter, dataProvider: DataProvider, storeManager: StoreManager) {
        self.presenter = presenter
        self.dataProvider = dataProvider
        self.storeManager = storeManager
    }
    
    deinit {
        print("SearchInteractor deinit")
    }
    
    // MARK: - Metods
    
    func getImageData(from urlString: String?, complete: @escaping ((UIImage?) -> Void)) {
        
        dataProvider.getImageData(urlString: urlString) { (data) in
            guard let data = data else { return }
            self.presenter.setIconImage(imageData: data, completion: complete)
        }
    }
    
    func loadStoreTracks() {
        storeManager.loadStoreTracks()
    }
    
    func getStoreTracksCount() -> Int {
        return storeManager.storeTracks.count
    }
    
    func getTrackFromStore(for index: Int) -> Track {
        return Track(storeTrack: storeManager.storeTracks[index])
    }
    
    func deleteTrackFromStore(for index: Int) {
        storeManager.deleteTrack(for: index)
    }
}
