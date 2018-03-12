//
//  ResourceCache.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 12/3/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import UIKit

class PictogramCache {
    static var pictogramCache : PictogramCache = PictogramCache()
    var map : [String:SVGKImage] = [:]
    
    private init () {
    }
    
    func getFileResource(for hash: String, type: TipoRecurso) -> SVGKImage? {
        if let imagen = map[hash] {
            return imagen
        } else {
            if ResourceStore.resourceStore.fileExists(withHash: hash, type: type) {
                let url = ResourceStore.resourceStore.getFileResource(for: hash, type: type)
                if type == TipoRecurso.pictograma {
                    let anSVGImage: SVGKImage = SVGKImage(contentsOf: url)
                    //map[hash] = anSVGImage
                    return anSVGImage
                }
            }
            return nil
        }
    }
    
    func fileExists(withHash: String, type: TipoRecurso) -> Bool {
        return ResourceStore.resourceStore.fileExists(withHash: withHash, type: type)
    }
    
}
