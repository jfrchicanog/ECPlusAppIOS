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
                if let imagen = resourceCache.getFileResource(for: hash, type: TipoRecurso.pictograma) {
                    return imagen
                }
            }
        }
        for elemento in palabra.recursos! {
            if let recurso = (elemento as? RecursoAudioVisual) {
                if (recurso.tipo == TipoRecurso.pictograma.rawValue) {
                    let hash = recurso.getFichero(for: Resolution.baja)!.hashvalue!                    
                    if let imagen = resourceCache.getFileResource(for: hash, type: TipoRecurso.pictograma) {
                        return imagen
                    }
                }
            }
        }
        return nil
    }
    
    static func clearCache() {
        self.resourceCache.clearCache()
    }
    
    static func preloadPictograms(palabras: [PalabraEntity]) {
        /*
        OperationQueue().addOperation {
            for palabra in palabras {
                getLogoFromWord(palabra: palabra)
            }
        }*/
    }
}
