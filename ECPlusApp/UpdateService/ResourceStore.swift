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
    
    init () {
        let urls = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        guard urls.count != 0 else {
            fatalError("No document directory in local domain")
        }
        do {
            dirURL = urls[0].appendingPathComponent(subpathName)
            if !fm.fileExists(atPath: dirURL.absoluteString) {
                try fm.createDirectory(at: dirURL, withIntermediateDirectories: false, attributes:nil)
            }
        } catch {
            NSLog("Error creating directory \(error)")
        }
    }
    
    func getFileResource(for hash: String, type: TipoRecurso) -> URL {
        let url = dirURL.appendingPathComponent(hash.lowercased())
        if type == TipoRecurso.video {
            return url.appendingPathExtension("mp4")
        } else {
            return url
        }
    }
    
    func fileExists(withHash: String, type: TipoRecurso) -> Bool {
        return fm.fileExists(atPath: getFileResource(for: withHash, type: type).absoluteString)
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
