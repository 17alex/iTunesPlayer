//
//  ResponsModel.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Decodable {
    let trackId: Int
    let artistName: String?
    let trackName: String?
    let artworkUrl60: String?
    let previewUrl: String?
    
    init(storeTrack: StoreTrack) {
        trackId = Int(storeTrack.trackId)
        artistName = storeTrack.artistName
        trackName = storeTrack.trackName
        artworkUrl60 = storeTrack.artworkUrl60
        previewUrl = storeTrack.previewUrl
    }
}
