//
//  StoreManager.swift
//  iTunesPlayer
//
//  Created by Alex on 07.02.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreData

class StoreManager {
    
    var storeTracks: [StoreTrack] = []
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistentStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext

    // MARK: - CRUD

    func saveContext () {
//        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadStoreTracks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoreTrack")
        if let tracks = try? context.fetch(fetchRequest) as? [StoreTrack] {
            self.storeTracks =  tracks
        }
        print("storeTracks count = \(storeTracks.count)")
    }
    
    func deleteTrack(index: Int) {
        context.delete(storeTracks.remove(at: index))
        saveContext ()
    }
    
    func addTrackToStore(track: Track) {
        let storeTrack = StoreTrack(context: context)
        storeTrack.trackName = track.trackName
        storeTrack.artistName = track.artistName
        storeTrack.artworkUrl60 = track.artworkUrl60
        storeTrack.previewUrl = track.previewUrl
        saveContext ()
    }
    
    // MARK: - Metods
    
    func containsTrack(track: Track) -> Bool {
        let tmpTrack = StoreTrack(context: context)
        tmpTrack.trackName = track.trackName
        tmpTrack.artistName = track.artistName
        tmpTrack.artworkUrl60 = track.artworkUrl60
        tmpTrack.previewUrl = track.previewUrl
        defer {
            context.delete(tmpTrack)
        }
        let st = storeTracks.contains(tmpTrack)
        print("containsTrack = \(st)")
        return st
    }
}
