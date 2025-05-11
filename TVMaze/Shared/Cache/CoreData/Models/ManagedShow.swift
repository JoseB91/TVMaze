//
//  ManagedShow.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import CoreData

@objc(ManagedShow)
class ManagedShow: NSManagedObject {
    @NSManaged var id: Int16
    @NSManaged var name: String
    @NSManaged var data: Data?
    @NSManaged var imageURL: URL
    @NSManaged var schedule: String
    @NSManaged var genres: String
    @NSManaged var summary: String
    @NSManaged var rating: String
    @NSManaged var isFavorite: Bool
    @NSManaged var cache: ManagedCache
}

extension ManagedShow {
    static func getImageData(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let cachedData = URLImageCache.shared.getImageData(for: url) {
            return cachedData
        }

        if let league = try getFirst(with: url, in: context), let imageData = league.data {
            URLImageCache.shared.setImageData(imageData, for: url)
            return imageData
        }
        
        return nil
    }
    
    static func getFirst(with url: URL, in context: NSManagedObjectContext) throws -> ManagedShow? {
        let request = NSFetchRequest<ManagedShow>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedShow.imageURL), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func fetchShows(from localShows: [LocalShow], in context: NSManagedObjectContext) -> NSOrderedSet {
        let orderedSet = NSOrderedSet(array: localShows.map { local in
            let managedShow = ManagedShow(context: context)
            managedShow.id = Int16(local.id)
            managedShow.name = local.name
            managedShow.imageURL = local.imageURL
            managedShow.schedule = local.schedule
            managedShow.genres = local.genres
            managedShow.schedule = local.schedule
            managedShow.rating = local.rating
            managedShow.isFavorite = local.isFavorite
            if let cachedData = URLImageCache.shared.getImageData(for: local.imageURL) {
                managedShow.data = cachedData
            }
            return managedShow
        })
        return orderedSet
    }
    
    static func find(with id: Int, in context: NSManagedObjectContext) throws -> ManagedShow? {
        let request = NSFetchRequest<ManagedShow>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    var local: LocalShow {
        return LocalShow(id: Int(id),
                         name: name,
                         imageURL: imageURL,
                         schedule: schedule,
                         genres: genres,
                         summary: summary,
                         rating: rating,
                         isFavorite: isFavorite)
    }
}
