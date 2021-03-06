//
//  LibraryPresenter.swift
//  iTunesPlayer
//
//  Created by Alex on 07.02.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class LibraryPresenter {
    
    // MARK: - Propertis
    
    private unowned let libraryView: LibraryViewController
    
    // MARK: - Init
    
    init(libraryView: LibraryViewController) {
        self.libraryView = libraryView
    }
    
    deinit {
        print("LibraryPresenter deinit")
    }
    
    // MARK: - Metods
    
    func setIconImage(imageData: Data, completion: ((UIImage?) -> Void)) {
        let image = UIImage(data: imageData)
        completion(image)
    }
}
