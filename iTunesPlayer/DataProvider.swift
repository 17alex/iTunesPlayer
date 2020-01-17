//
//  DataProvider.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class DataProvider {
    
    func getSearchResponse(width text: String, completion: @escaping ((Data?, Error?) -> Void)) {
        
        let urlString = "https://itunes.apple.com/search?term=\(text)&limit=25"
        guard let url = URL(string: urlString) else { fatalError() }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error { completion(nil, error) }
                if let data = data   { completion(data, nil) }
            }
        }.resume()
    }
    
    func getImageData(urlString: String?, completion: @escaping (Data?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let _ = error   { completion(nil) }
                if let data = data { completion(data) }
            }
        }.resume()
    }
}
