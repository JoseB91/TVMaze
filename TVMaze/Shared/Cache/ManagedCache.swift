//
//  ManagedCache.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var shows: NSOrderedSet
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try deleteCache(in: context)
        return ManagedCache(context: context)
    }
    
    static func cacheExists(in context: NSManagedObjectContext) throws -> Bool {
        try find(in: context) != nil
    }
    
    var localShows: [LocalShow] {
        return shows.compactMap { ($0 as? ManagedShow)?.local }
    }
}
