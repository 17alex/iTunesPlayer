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
    
    func loadTracks(width text: String) {
        
        dataProvider.getSearchResponse(width: text) { (data, error) in
            
            if let error = error {
                self.presenter.presentAlert(with: error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    self.prepareTracks(searchResponse: searchResponse)
                } catch let jsonError {
                    self.presenter.presentAlert(with: jsonError.localizedDescription)
                }
            }
        }
    }
    
    func prepareTracks(searchResponse: SearchResponse) {
        tracks = searchResponse.results
        presenter.tracksLoaded()
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
    
    func getLoadedTracksCount() -> Int {
        return tracks.count
    }
    
    func getLoadedTrack(for index: Int) -> Track {
        return tracks[index]
    }
    
    func addLoadedTrackToStore(track: Track) {
        storeManager.addTrackToStore(track: track)
    }
    
    func containsLoadedTrackInStore(track: Track) -> Bool {
        storeManager.containsTrack(track: track)
    }
    
}
