//
//  SearchPresenter.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class SearchPresenter {
    
    private unowned let searchView: SearchViewController
    
    init(searchView: SearchViewController) {
        self.searchView = searchView
    }
    
    deinit {
        print("SearchPresenter deinit")
    }
    
    func prepareSet(searchResponse: SearchResponse) {
        let tracks = searchResponse.results
        searchView.set(tracks: tracks)
    }
    
    func presentAlert(with text: String) {
        searchView.presentAlert(with: text)
    }
    
    func setIconImage(imageData: Data, completion: ((UIImage?) -> Void)) {
        let image = UIImage(data: imageData)
        completion(image)
    }
    
}
