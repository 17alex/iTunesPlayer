//
//  LibraryInteractor.swift
//  iTunesPlayer
//
//  Created by Alex on 07.02.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class LibraryInteractor {
    
    private unowned let presenter: LibraryPresenter
    private unowned let dataProvider: DataProvider
    
    init(presenter: LibraryPresenter, dataProvider: DataProvider) {
        self.presenter = presenter
        self.dataProvider = dataProvider
    }
    
    deinit {
        print("SearchInteractor deinit")
    }
    
    func getImageData(from urlString: String?, complete: @escaping ((UIImage?) -> Void)) {
        
        dataProvider.getImageData(urlString: urlString) { (data) in
            guard let data = data else { return }
            self.presenter.setIconImage(imageData: data, completion: complete)
        }
    }
}
