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
                fatalError("loadPersistentStores >>> Unresolved error \(error), \(error.userInfo)")
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
                fatalError("saveContext >>> Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadStoreTracks() {
        let fetchRequest = NSFetchRequest<StoreTrack>(entityName: "StoreTrack")
        do {
            let tracks = try context.fetch(fetchRequest)
            self.storeTracks =  tracks
            print("storeTracks count = \(storeTracks.count)")
        } catch let error {
            fatalError("loadStoreTracks >>> \(error.localizedDescription)")
        }
    }
    
    func deleteTrack(index: Int) {
        context.delete(storeTracks.remove(at: index))
        saveContext ()
    }
    
    func addTrackToStore(track: Track) {
        let addStoreTrack = StoreTrack(context: context)
        addStoreTrack.trackName = track.trackName
        addStoreTrack.artistName = track.artistName
        addStoreTrack.artworkUrl60 = track.artworkUrl60
        addStoreTrack.previewUrl = track.previewUrl
        print("track.trackId =  \(track.trackId)")
        addStoreTrack.trackId = Int64(track.trackId)
        saveContext ()
        storeTracks.append(addStoreTrack)
    }
    
    // MARK: - Metods
    
    func containsTrack(track: Track) -> Bool {
        let fetchRequest = NSFetchRequest<StoreTrack>(entityName: "StoreTrack")
        fetchRequest.predicate = NSPredicate(format: "trackId = %@", "\(track.trackId)")
        do {
            let tracks = try context.fetch(fetchRequest)
            if tracks.count > 0 {
                return true
            }
            return false
        } catch let error {
            fatalError("loadStoreTracks >>> \(error.localizedDescription)")
        }
    }
    
}
