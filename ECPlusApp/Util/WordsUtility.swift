//
//  WordsUtility.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 15/3/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
class WordsUtility {
    static let resourceCache = PictogramCache.pictogramCache
    
    static func getLogoFromWord(palabra: PalabraEntity) -> UIImage? {
        if let recurso = palabra.icono {
            if (recurso.tipo == TipoRecurso.pictograma.rawValue) {
                let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
                /*
                 let url = ResourceStore.resourceStore.getFileResource(for: hash, type: TipoRecurso.pictograma)
                 if ResourceStore.resourceStore.fileExists(withHash: hash, type: TipoRecurso.pictograma) {
                 let anSVGImage: SVGKImage = SVGKImage(contentsOf: url)
                 if let imagen = anSVGImage.uiImage {
                 return imagen
                 }
                 }*/
                if let imagen = resourceCache.getFileResource(for: hash, type: TipoRecurso.pictograma) {
                    return imagen
                }
            }
        }
        for elemento in palabra.recursos! {
            if let recurso = (elemento as? RecursoAudioVisual) {
                if (recurso.tipo == TipoRecurso.pictograma.rawValue) {
                    let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!
                    /*
                     let url = ResourceStore.resourceStore.getFileResource(for: hash, type: TipoRecurso.pictograma)
                     if ResourceStore.resourceStore.fileExists(withHash: hash, type: TipoRecurso.pictograma) {
                     let anSVGImage: SVGKImage = SVGKImage(contentsOf: url)
                     if let imagen = anSVGImage.uiImage {
                     return imagen
                     }
                     }*/
                    
                    if let imagen = resourceCache.getFileResource(for: hash, type: TipoRecurso.pictograma) {
                        return imagen
                    }
                }
            }
        }
        return nil
    }
}
