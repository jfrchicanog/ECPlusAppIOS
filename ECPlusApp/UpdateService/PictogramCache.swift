//
//  ResourceCache.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 12/3/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PictogramCache {
    static var pictogramCache : PictogramCache = PictogramCache()
    var map : [String:UIImage] = [:]
    let size = CGSize(width: 75, height: 75)
    
    private init () {
    }
    
    func getFileResource(for hash: String, type: TipoRecurso) -> UIImage? {
        if let imagen = map[hash] {
            return imagen
        } else {
            if ResourceStore.resourceStore.fileExists(withHash: hash, type: type) {
                let url = ResourceStore.resourceStore.getFileResource(for: hash, type: type)
                if type == TipoRecurso.pictograma {
                    let anSVGImage: SVGKImage = SVGKImage(contentsOf: url)
                    
                    let uiImage = SVGKExporterUIImage.export(asUIImage: anSVGImage)
                    
                    UIGraphicsBeginImageContext(size)
                    let rect = AVMakeRect(aspectRatio: uiImage!.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
                    uiImage?.draw(in: rect)
                    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    map[hash] = scaledImage
                    return scaledImage
                }
            }
            return nil
        }
    }
    
    func clearCache() {
        map.removeAll()
    }
    
    func fileExists(withHash: String, type: TipoRecurso) -> Bool {
        return ResourceStore.resourceStore.fileExists(withHash: withHash, type: type)
    }
    
}
