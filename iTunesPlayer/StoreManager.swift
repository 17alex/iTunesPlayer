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
    
    var tracks: [StoreTrack] = []
    
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
    
    func loadTracks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoreTrack")
        if let tracks = try? context.fetch(fetchRequest) as? [StoreTrack] {
            self.tracks =  tracks
        }
    }
    
    func deleteTrack(index: Int) {
        context.delete(tracks.remove(at: index))
        saveContext ()
    }
    
    func addTrackToStore(name: String, artistName: String) {
        let track = StoreTrack(context: context)
        track.trackName = name
        track.artistName = artistName
        saveContext ()
    }
}
