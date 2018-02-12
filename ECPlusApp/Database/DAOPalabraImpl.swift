//
//  DAOPalabraImpl.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import CoreData

class DAOPalabraImpl: DAOPalabra {
    private let context = DataController.context;
    
    private func getListOfWords(language: String) throws -> ListaPalabras? {
        let listaFetch: NSFetchRequest<ListaPalabras> = ListaPalabras.fetchRequest()
        listaFetch.predicate = NSPredicate(format: "idioma = '\(language)'")
        return try context.fetch(listaFetch).last
    }
    
    func getHashForListOfWords(language: String, resolucion: Resolution) -> String? {
        do {
            if let lista = try getListOfWords(language: language) {
                if let hash=lista.getHash(for: resolucion) {
                    return hash.hashvalue;
                }
            }
            return nil;
        } catch {
            fatalError("Failed to get Hash of Words: \(error)")
        }
    }
    
    func removeAllResourcesForWordsList(language: String, resolution: Resolution) {
        // TODO
    }
    
    func createListOfWords(language: String) {
        do {
            guard (try getListOfWords(language: language)) != nil else {
                let listaPalabras = NSEntityDescription.insertNewObject(forEntityName: "ListaPalabras", into: context) as! ListaPalabras;
                listaPalabras.idioma = language;
                listaPalabras.id = 0;
                try context.save()
                return
            }
        } catch {
            fatalError("Failed to get list of words: \(error)")
        }
    }
    
    func getWords(language: String, resolution: Resolution) -> [PalabraEntity] {
        do {
            if let lista = try getListOfWords(language: language) {
                if let palabras = lista.palabras as? Set<PalabraEntity>{
                    return Array(palabras)
                }
            }
            return []
        } catch {
            fatalError("Failed to get Words: \(error)")
        }
    }
    
    func addWord(word: Palabra, language: String, resolution: Resolution) {
        do {
            let listaPalabras = try getListOfWords(language: language)
            let palabra = NSEntityDescription.insertNewObject(forEntityName: "PalabraEntity", into: context) as! PalabraEntity;
            
            palabra.id = word.id;
            palabra.nombre = word.nombre;
            
            if let avanzada = word.avanzada {
                palabra.avanzada = avanzada
            } else {
                palabra.avanzada = false
            }
            
            if let iconoReemplazable = word.iconoReemplazable {
                palabra.iconoReemplazable = iconoReemplazable
            } else {
                palabra.iconoReemplazable = false
            }
            
            palabra.lista = listaPalabras!
            
            for rav in word.audiovisuales {
                let recurso = createResource(rav: rav, resolution: resolution)
                
                if let icono = word.icono {
                    if (recurso.id == icono) {
                        palabra.icono = recurso;
                    }
                }
                palabra.addToRecursos(recurso);
            }
            
            let hash = NSEntityDescription.insertNewObject(forEntityName: "HashPalabra", into: context) as! HashPalabra;
            
            hash.resolucion = resolution.rawValue
            hash.hashvalue = word.hash
            
            palabra.addToHashes(hash)
            try context.save()

        } catch {
            fatalError("Failed to add word: \(error)")
        }
        
    }
    
    private func createResource(rav: RecursoAudioVisualWS, resolution: Resolution) -> RecursoAudioVisual {
        let fichero = NSEntityDescription.insertNewObject(forEntityName: "Fichero", into: context) as! Fichero
        fichero.resolucion = resolution.rawValue
        fichero.hashvalue = rav.hash
        
        let recurso = NSEntityDescription.insertNewObject(forEntityName: "RecursoAudioVisual", into: context) as! RecursoAudioVisual
        recurso.id = rav.id
        recurso.tipo = rav.type?.rawValue
        recurso.addToFicheros(fichero)
        
        return recurso

    }
    
    func updateWord(remote: Palabra) {
        // TODO
    }
    
    func updateUso(palabra: PalabraEntity) {
        // TODO
    }
    
    func setHashForListOfWords(language: String, resolution: Resolution, hash: String) {
        do {
            let lista = try getListOfWords(language: language)
            var hashLista = lista?.getHash(for: resolution)
            if (hashLista == nil) {
                hashLista = NSEntityDescription.insertNewObject(forEntityName: "HashListaPalabras", into: context) as? HashListaPalabras
                lista?.addToHashes(hashLista!)
            }
            
            hashLista?.hashvalue = hash
            hashLista?.resolucion = resolution.rawValue
        } catch {
            fatalError("Failed to change hash for list of words \(error)")
        }
    }
    
    func removeWord(word: PalabraEntity) {
        do {
            context.delete(word)
            try context.save()
        } catch {
            fatalError("Failed to remove word \(error)")
        }
    }
    
    func getAllHashes() -> [String] {
        do {
            let ficheroFetch: NSFetchRequest<Fichero> = Fichero.fetchRequest()
            let ficheros = try context.fetch(ficheroFetch)
            return ficheros.flatMap({(f) in
                return f.hashvalue
            })
        } catch {
            fatalError("Failed to fetch hashes \(error)")
        }
    }
    
    
}
