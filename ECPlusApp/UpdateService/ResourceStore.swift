//
//  ResourceStore.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 11/2/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class ResourceStore {
    let subpathName = "resources"
    let fm : FileManager = FileManager.default
    var dirURL: URL
    var cacheURL : URL
    
    static var resourceStore: ResourceStore = ResourceStore()
    
    private init () {
        let urls = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        guard urls.count != 0 else {
            fatalError("No document directory in local domain")
        }
        
        let cacheURLs = fm.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        guard cacheURLs.count != 0 else {
            fatalError("No cache directory in local domain")
        }
        
        do {
            cacheURL = cacheURLs[0]
            dirURL = urls[0].appendingPathComponent(subpathName)
            try fm.createDirectory(at: dirURL, withIntermediateDirectories: false, attributes:nil)
        } catch {
        }
    }
    
    func getFileResource(for hash: String, type: TipoRecurso) -> URL {
        let url = dirURL.appendingPathComponent(hash.lowercased())
        if type == TipoRecurso.video {
            return url.appendingPathExtension("mp4")
        } else if type == TipoRecurso.audio {
            return url.appendingPathExtension("mp3")
        } else {
            return url
        }
    }
    
    func getCachedBitmap(for hash: String) -> URL {
        return cacheURL.appendingPathComponent(hash.lowercased()).appendingPathExtension(".png")
    }
    
    func fileExists(withHash: String, type: TipoRecurso) -> Bool {
        do {
            let file = try FileHandle(forReadingFrom: getFileResource(for: withHash, type: type))
            file.closeFile()
            return true
        } catch {
            return false;
        }
    }
    
    func getAllFileResourcesInStore() -> [URL] {
        var dir : ObjCBool = false
        if let files = fm.subpaths(atPath: dirURL.absoluteString) {
            return files.filter({(file) in
                dir = false
                return fm.isReadableFile(atPath: file) &&
                    fm.fileExists(atPath: file, isDirectory: &dir) &&
                    dir.boolValue;
            }).map({(file) in
                return URL(fileURLWithPath: file)
            })
        } else {
            return []
        }
    }
}
