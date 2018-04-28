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
    
    func getCategorias(language: String, context: NSManagedObjectContext) -> [Categoria] {
        do {
            if let lista = try getListOfWords(context: context, language: language) {
                if let categorias = lista.categorias as? Set<Categoria>{
                    return Array(categorias)
                }
            }
            return []
        } catch {
            fatalError("Failed to get Categorias: \(error)")
        }
    }
    
    func save() {
            let context: NSManagedObjectContext = DataController.dataController.getPrivateQueueContext()
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    NSLog("Error saving private context \(error)")
                }
            }
    }
    
    public func getListOfWords(context: NSManagedObjectContext, language: String) throws -> ListaPalabras? {
        let listaFetch: NSFetchRequest<ListaPalabras> = ListaPalabras.fetchRequest()
        listaFetch.predicate = NSPredicate(format: "idioma = '\(language)'")
        return try context.fetch(listaFetch).last
    }
    
    func getHashForListOfWords(language: String, resolucion: Resolution) -> String? {
        let context = DataController.dataController.getPrivateQueueContext()
        var result: String? = nil
        context.performAndWait {
            do {
                if let lista = try getListOfWords(context: context, language: language) {
                    if let hash=lista.getHash(for: resolucion) {
                        result = hash.hashvalue;
                    }
                }
            } catch {
                fatalError("Failed to get Hash of Words: \(error)")
            }
        }
        return result;
    }
    
    func removeAllResourcesForWordsList(language: String, resolution: Resolution) {
        
        // TODO
    }
    
    func createListOfWords(language: String) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait {
            do {
                guard (try getListOfWords(context: context, language: language)) != nil else {
                    let listaPalabras = NSEntityDescription.insertNewObject(forEntityName: "ListaPalabras", into: context) as! ListaPalabras;
                    listaPalabras.idioma = language;
                    listaPalabras.id = 0;
                    try context.save()
                    return
                }
            } catch {
                fatalError("Failed to create list of words: \(error)")
            }
        }
    }
    
    func getWords(language: String, context: NSManagedObjectContext) -> [PalabraEntity] {
        do {
            if let lista = try getListOfWords(context: context, language: language) {
                if let palabras = lista.palabras as? Set<PalabraEntity>{
                    return Array(palabras)
                }
            }
            return []
        } catch {
            fatalError("Failed to get Words: \(error)")
        }
    }
    
    func getWords(language: String, resolution: Resolution) -> [PalabraEntity] {
        do {
            if let lista = try getListOfWords(context: DataController.dataController.mainQueueContext, language: language) {
                if let palabras = lista.palabras as? Set<PalabraEntity>{
                    return Array(palabras)
                }
            }
            return []
        } catch {
            fatalError("Failed to get Words: \(error)")
        }
    }
    
    
    func addWord(context: NSManagedObjectContext, word: Palabra, categoria: Categoria?, language: String, resolution: Resolution) {
        context.performAndWait {
            do {
                let listaPalabras = try getListOfWords(context: context, language: language)
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
                palabra.categoria = categoria
                
                for rav in word.audiovisuales {
                    let recurso = createResource(context: context, rav: rav, resolution: resolution)
                    
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
    }
    
    private func createResource(context: NSManagedObjectContext, rav: RecursoAudioVisualWS, resolution: Resolution) -> RecursoAudioVisual {
        let fichero = NSEntityDescription.insertNewObject(forEntityName: "Fichero", into: context) as! Fichero
        fichero.resolucion = resolution.rawValue
        fichero.hashvalue = rav.hash
        
        let recurso = NSEntityDescription.insertNewObject(forEntityName: "RecursoAudioVisual", into: context) as! RecursoAudioVisual
        recurso.id = rav.id
        recurso.tipo = rav.type?.rawValue
        recurso.addToFicheros(fichero)
        
        return recurso

    }
    
    fileprivate func updateRecursos(context: NSManagedObjectContext, local: PalabraEntity, remote: Palabra, resolution: Resolution) {
        let localRecursos = (local.recursos! as! Set<RecursoAudioVisual>).sorted(by: {$0.id < $1.id})
        let remoteRecursos = remote.audiovisuales.sorted(by: {$0.id < $1.id})
        
        var localIterator : Int = 0
        var remoteIterator : Int = 0
        
        while (localIterator < localRecursos.count || remoteIterator  < remoteRecursos.count) {
            if (localIterator >= localRecursos.count) {
                let recurso = createResource(context: context, rav: remoteRecursos[remoteIterator], resolution: resolution)
                local.addToRecursos(recurso)
                if let icono = remote.icono {
                    if (recurso.id == icono) {
                        local.icono = recurso;
                    }
                }
                remoteIterator = remoteIterator + 1
            } else if (remoteIterator >= remoteRecursos.count) {
                context.delete(localRecursos[localIterator])
                localIterator = localIterator + 1
            } else if (localRecursos[localIterator].id > remoteRecursos[remoteIterator].id) {
                let recurso = createResource(context: context, rav: remoteRecursos[remoteIterator], resolution: resolution)
                local.addToRecursos(recurso)
                if let icono = remote.icono {
                    if (recurso.id == icono) {
                        local.icono = recurso;
                    }
                }
                remoteIterator = remoteIterator + 1
            } else if (localRecursos[localIterator].id < remoteRecursos[remoteIterator].id) {
                context.delete(localRecursos[localIterator])
                localIterator = localIterator + 1
            } else {
                localRecursos[localIterator].tipo = remoteRecursos[remoteIterator].type?.rawValue
                let recurso = localRecursos[localIterator]
                
                if let icono = remote.icono {
                    if (recurso.id == icono) {
                        local.icono = recurso;
                    }
                }
  
                if let fichero = localRecursos[localIterator].getFichero(for: resolution) {
                    fichero.hashvalue = remoteRecursos[remoteIterator].hash
                } else {
                    let fichero = NSEntityDescription.insertNewObject(forEntityName: "Fichero", into: context) as! Fichero
                    fichero.resolucion = resolution.rawValue
                    fichero.hashvalue = remoteRecursos[remoteIterator].hash
                    localRecursos[localIterator].addToFicheros(fichero)
                }
                localIterator = localIterator + 1
                remoteIterator = remoteIterator + 1
            }
            
        }
    }
    
    func updateWord(context: NSManagedObjectContext, local: PalabraEntity, remote: Palabra, categoria: Categoria?, resolution: Resolution) {
        context.performAndWait {
            do {
                local.nombre = remote.nombre;
                
                if let avanzada = remote.avanzada {
                    local.avanzada = avanzada
                } else {
                    local.avanzada = false
                }
                
                if let iconoReemplazable = remote.iconoReemplazable {
                    local.iconoReemplazable = iconoReemplazable
                } else {
                    local.iconoReemplazable = false
                }
                
                local.categoria = categoria
                
                updateRecursos(context: context, local: local, remote: remote, resolution: resolution)

                if let hashPalabra = local.getHash(for: resolution) {
                    hashPalabra.hashvalue = remote.hash
                } else {
                    let hash = NSEntityDescription.insertNewObject(forEntityName: "HashPalabra", into: context) as! HashPalabra;
                    
                    hash.resolucion = resolution.rawValue
                    hash.hashvalue = remote.hash
                    
                    local.addToHashes(hash)
                }

                try context.save()
                
            } catch {
                fatalError("Failed to add word: \(error)")
            }
        }
    }
    
    func updateUso(palabra: PalabraEntity) {
        // TODO
    }
    
    func setHashForListOfWords(context: NSManagedObjectContext, language: String, resolution: Resolution, hash: String) {
        context.performAndWait {
            do {
                let lista = try getListOfWords(context: context, language: language)
                var hashLista = lista?.getHash(for: resolution)
                if (hashLista == nil) {
                    hashLista = NSEntityDescription.insertNewObject(forEntityName: "HashListaPalabras", into: context) as? HashListaPalabras
                    lista?.addToHashes(hashLista!)
                }
                
                hashLista?.hashvalue = hash
                hashLista?.resolucion = resolution.rawValue
                try context.save()
            } catch {
                fatalError("Failed to change hash for list of words \(error)")
            }
        }
    }
    
    func removeWord(context: NSManagedObjectContext, word: PalabraEntity) {
        context.performAndWait {
            do {
                context.delete(word)
                try context.save()
            } catch {
                NSLog("Error removeing word \(error)")
            }
        }
    }
    
    func getAllHashes() -> [String] {
        let context = DataController.dataController.getPrivateQueueContext()
        var result : [String] = [];
        context.performAndWait {
            do {
                let ficheroFetch: NSFetchRequest<Fichero> = Fichero.fetchRequest()
                let ficheros = try context.fetch(ficheroFetch)
                result.append(contentsOf: ficheros.flatMap({$0.hashvalue }))
            } catch {
                fatalError("Failed to fetch hashes \(error)")
            }
        }
        return result
    }
    
    
}
