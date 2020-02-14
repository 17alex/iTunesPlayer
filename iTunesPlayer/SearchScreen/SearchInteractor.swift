//
//  SearchInteractor.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class SearchInteractor {
    
    private unowned let presenter: SearchPresenter
    private unowned let dataProvider: DataProvider
    private unowned let storeManager: StoreManager
    
    private var tracks: [Track] = []
    
    init(presenter: SearchPresenter, dataProvider: DataProvider, storeManager: StoreManager) {
        self.presenter = presenter
        self.dataProvider = dataProvider
        self.storeManager = storeManager
    }
    
    deinit {
        print("SearchInteractor deinit")
    }
    
    func getData(width text: String) {
        
        dataProvider.getSearchResponse(width: text) { (data, error) in
            
            if let error = error {
                self.presenter.presentAlert(with: error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    self.presenter.prepareSet(searchResponse: searchResponse)
                } catch let jsonError {
                    self.presenter.presentAlert(with: jsonError.localizedDescription)
                }
            }
        }
    }
    
    func getImageData(from urlString: String?, complete: @escaping ((UIImage?) -> Void)) {
        
        dataProvider.getImageData(urlString: urlString) { (data) in
            guard let data = data else { return }
            self.presenter.setIconImage(imageData: data, completion: complete)
        }
    }
    
    func loadStoreTracks() {
        storeManager.loadStoreTracks()
    }
    
//    func getStoreTracksCount() -> Int {
//        return storeManager.storeTracks.count
//    }
    
//    func getTrackFromStore(for index: Int) -> Track {
//        return Track(storeTrack: storeManager.storeTracks[index])
//    }
    
//    func deleteTrackFromStore(for index: Int) {
//        storeManager.deleteTrack(for: index)
//    }
    
}
