//
//  StoreTrack+CoreDataProperties.swift
//  iTunesPlayer
//
//  Created by Alex on 07.02.2020.
//  Copyright © 2020 Alex. All rights reserved.
//
//

import Foundation
import CoreData


extension StoreTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreTrack> {
        return NSFetchRequest<StoreTrack>(entityName: "StoreTrack")
    }

    @NSManaged public var artistName: String?
    @NSManaged public var trackName: String?
    @NSManaged public var artworkUrl60: String?
    @NSManaged public var previewUrl: String?

}
