//
//  URLImageCache.swift
//  TVMaze
//
//  Created by José Briones on 10/5/25.
//

import Foundation

class URLImageCache {
    static let shared = URLImageCache()
    
    private let cache = NSCache<NSURL, NSData>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    func setImageData(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    func getImageData(for url: URL) -> Data? {
        return cache.object(forKey: url as NSURL) as Data?
    }
    
    func hasImageData(for url: URL) -> Bool {
        return cache.object(forKey: url as NSURL) != nil
    }
    
    func removeImageData(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
