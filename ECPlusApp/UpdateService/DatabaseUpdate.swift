//
//  DatabaseUpdate.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import CoreData

class DatabaseUpdate {
    let daoSindrome : DAOSindrome = DAOFactory.getDAOSindrome()
    let daoPalabra : DAOPalabra = DAOFactory.getDAOPalabra()
    let wsSindrome : WSSindrome = WSSindromeImpl()
    let wsPalabra : WSPalabra = WSPalabraImpl()
    let updateServiceCoordinator = UpdateCoordinator.coordinator;
    let resourceStore : ResourceStore = ResourceStore.resourceStore
    
    var categories: [CategoriaREST]? = nil
    var words : [Palabra]? = nil
    var categoryMap : [Int: Categoria] = [:]
    
    let cola = OperationQueue()
    
    static var _databaseUpdate : DatabaseUpdate?
    
    static func getDatabaseUpdate() -> DatabaseUpdate {
        if _databaseUpdate == nil {
            _databaseUpdate = DatabaseUpdate()
        }
        return _databaseUpdate!
    }
    
    private init () {
    }
    
    func updatePalabras(language: String, resolution: Resolution, completion: @escaping ()->Void) {
        self.updateServiceCoordinator.fireEvent(event: UpdateEvent.startUpdateWordsEvent())
        wsPalabra.getHashForListOfWords(language: language, resolution: resolution, completion: {(hashRemote) in
            guard hashRemote != nil else {
                NSLog("Nil remote hash")
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsEvent(databaseChanged: false))
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsFileEvent(filesChanged: false));
                completion();
                return
            }
            
            NSLog("Hash words: \(hashRemote!)")
            let hashLocal = self.daoPalabra.getHashForListOfWords(language: language, resolucion: resolution)
            
            if hashRemote == nil {
                self.daoPalabra.removeAllResourcesForWordsList(language: language, resolution: resolution)
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsEvent(databaseChanged: true))
                
                self.removeUnusedFiles();
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsFileEvent(filesChanged: false));
                completion()
                
            } else if hashLocal == nil || hashLocal!.caseInsensitiveCompare(hashRemote!) != ComparisonResult.orderedSame {
                if hashLocal == nil {
                    self.daoPalabra.createListOfWords(language: language)
                }
                self.updateLocalWordList(language: language, resolution: resolution, remoteHash: hashRemote!,completion: {
                    self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsEvent(databaseChanged: true))
                    self.removeUnusedFiles();
                    self.updateFiles(language: language, resolution: resolution, completion: completion);
                    
                })
            }  else {
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsEvent(databaseChanged: false))
                self.updateFiles(language: language, resolution: resolution, completion: completion)
            }
        })
    }
    
    func updateLocalWordList(language: String, resolution: Resolution, remoteHash: String, completion: @escaping () -> Void) {
        self.categories = nil
        self.words = nil
        wsPalabra.getCategories(language: language, completion: {remoteCategories in
            self.categories = remoteCategories;
            self.cola.addOperation {
                if self.words != nil {
                    self.updateWordsAndCategories(language: language, resolution: resolution, remoteHash: remoteHash, completion: completion)
                }
            }
        })
        wsPalabra.getWords(language: language, resolution: resolution, completion: {(rPalabras) in
            self.words = rPalabras
            self.cola.addOperation {
                if self.categories != nil {
                    self.updateWordsAndCategories(language: language, resolution: resolution, remoteHash: remoteHash, completion: completion)
                }
            }
        
        })
    }
    
    private func updateWordsAndCategories(language: String, resolution: Resolution, remoteHash: String, completion: @escaping () -> Void) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait {
            do {
                try self.updateCategoria(language: language, context: context)
                self.updateWords(language: language, resolution: resolution, context: context)
                self.daoPalabra.setHashForListOfWords(context: context, language: language, resolution: resolution, hash: remoteHash)
            } catch {
                NSLog("Error updating categories and words")
            }
        }
        completion();
    }
    
    private func updateCategoria(language: String, context: NSManagedObjectContext) throws {
        self.categoryMap.removeAll()
        
        let localCategorias = self.daoPalabra.getCategorias(language: language, context: context).sorted(by: {$0.id < $1.id})
        let remoteCategorias = categories!.sorted(by: {$0.id < $1.id})
        
        let listaPalabras = try self.daoPalabra.getListOfWords(context: context, language: language)
        
        var localIterator : Int = 0
        var remoteIterator : Int = 0
        
        while (localIterator < localCategorias.count || remoteIterator  < remoteCategorias.count) {
            if (localIterator >= localCategorias.count) {
                NSLog("Adding \(remoteCategorias[remoteIterator].nombre!)")
                let categoria = NSEntityDescription.insertNewObject(forEntityName: "Categoria", into: context) as! Categoria;
                categoria.id = remoteCategorias[remoteIterator].id
                categoria.nombre = remoteCategorias[remoteIterator].nombre
                listaPalabras?.addToCategorias(categoria)
                self.categoryMap[Int(categoria.id)] = categoria
                remoteIterator = remoteIterator + 1
            } else if (remoteIterator >= remoteCategorias.count) {
                NSLog("Removing \(localCategorias[localIterator].nombre!)")
                context.delete(localCategorias[localIterator])
                localIterator = localIterator + 1
            } else if (localCategorias[localIterator].id > remoteCategorias[remoteIterator].id) {
                NSLog("Adding \(remoteCategorias[remoteIterator].nombre!)")
                let categoria = NSEntityDescription.insertNewObject(forEntityName: "Categoria", into: context) as! Categoria;
                categoria.id = remoteCategorias[remoteIterator].id
                categoria.nombre = remoteCategorias[remoteIterator].nombre
                listaPalabras?.addToCategorias(categoria)
                self.categoryMap[Int(categoria.id)] = categoria
                remoteIterator = remoteIterator + 1
            } else if (localCategorias[localIterator].id < remoteCategorias[remoteIterator].id) {
                NSLog("Removing \(localCategorias[localIterator].nombre!)")
                context.delete(localCategorias[localIterator])
                localIterator = localIterator + 1
            } else {
                localCategorias[localIterator].nombre = remoteCategorias[remoteIterator].nombre
                self.categoryMap[Int(localCategorias[localIterator].id)] = localCategorias[localIterator]
                localIterator = localIterator + 1
                remoteIterator = remoteIterator + 1
            }
        }
    }
    
    private func updateWords(language: String, resolution: Resolution, context: NSManagedObjectContext) {
        let localPalabras = daoPalabra.getWords(language: language, context: context)
            .sorted(by: {$0.id < $1.id})
        let remotePalabras = words!.sorted(by: {$0.id < $1.id})
        
        var localIterator : Int = 0
        var remoteIterator : Int = 0
        
        while (localIterator < localPalabras.count || remoteIterator  < remotePalabras.count) {
            if (localIterator >= localPalabras.count) {
                let catForWord = (remotePalabras[remoteIterator].categoria==nil) ? nil : self.categoryMap[Int(remotePalabras[remoteIterator].categoria!)]
                
                NSLog("Adding \(remotePalabras[remoteIterator].id) localITerator \(localIterator) local count \(localPalabras.count)")
                self.daoPalabra.addWord(context: context, word: remotePalabras[remoteIterator], categoria: catForWord, language: language, resolution: resolution)
                remoteIterator = remoteIterator + 1
            } else if (remoteIterator >= remotePalabras.count) {
                NSLog("Removing \(localPalabras[localIterator].id)")
                self.daoPalabra.removeWord(context: context, word: localPalabras[localIterator])
                localIterator = localIterator + 1
            } else if (localPalabras[localIterator].id > remotePalabras[remoteIterator].id) {
                let catForWord = (remotePalabras[remoteIterator].categoria==nil) ? nil : self.categoryMap[Int(remotePalabras[remoteIterator].categoria!)]
                
                NSLog("Adding \(remotePalabras[remoteIterator].id)")
                self.daoPalabra.addWord(context: context, word: remotePalabras[remoteIterator], categoria: catForWord, language: language, resolution: resolution)
                remoteIterator = remoteIterator + 1
            } else if (localPalabras[localIterator].id < remotePalabras[remoteIterator].id) {
                NSLog("Removing \(localPalabras[localIterator].id)")
                self.daoPalabra.removeWord(context: context, word: localPalabras[localIterator])
                localIterator = localIterator + 1
            } else {
                if localPalabras[localIterator].getHash(for: resolution)!.hashvalue!.caseInsensitiveCompare(remotePalabras[remoteIterator].hash!) != ComparisonResult.orderedSame {
                    let catForWord = (remotePalabras[remoteIterator].categoria==nil) ? nil : self.categoryMap[Int(remotePalabras[remoteIterator].categoria!)]
                    
                    self.daoPalabra.updateWord(context: context, local: localPalabras[localIterator], remote: remotePalabras[remoteIterator], categoria: catForWord, resolution: resolution)
                }
                
                localIterator = localIterator + 1
                remoteIterator = remoteIterator + 1
            }
        }
    }
    
    
    private func removeUnusedFiles() {
        // TODO
    }
    
    private func updateFiles(language: String, resolution: Resolution, completion: @escaping () -> Void) {
        let palabras = daoPalabra.getWords(language: language, resolution: resolution)
        var numFiles : Int = 0;
        self.cola.addOperation {numFiles = numFiles + 1}
        for palabra in palabras {
            if let recursos = palabra.recursos as? Set<RecursoAudioVisual> {
                for recurso in recursos {
                    if let fichero = recurso.getFichero(for: resolution) {
                        let tipo = TipoRecurso(rawValue: recurso.tipo!)!
                        if !resourceStore.fileExists(withHash: fichero.hashvalue!, type: tipo) {
                            self.cola.addOperation {numFiles = numFiles + 1}
                            wsPalabra.getResource(hash: fichero.hashvalue!, toFile: resourceStore.getFileResource(for: fichero.hashvalue!, type: tipo), completion: {
                                self.cola.addOperation {
                                    numFiles = numFiles - 1
                                    if (numFiles <= 0) {
                                        completion()
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
        self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsFileEvent(filesChanged: true));
        self.cola.addOperation {
            numFiles = numFiles - 1
            if (numFiles <= 0) {
                completion()
            }
        }
        // TODO
    }
    
    func updateSindromes(language: String, completion: @escaping () -> Void) {
        self.updateServiceCoordinator.fireEvent(event: UpdateEvent.startUpdateSyndromesEvent())
        wsSindrome.getHashForListOfSyndromes(language: language, completion: {(hashRemote) in
            guard hashRemote != nil  else {
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: false))
                completion()
                return;
            }
            
            let hashLocal = self.daoSindrome.getHashForListOfSyndromes(language: language)
            if hashRemote == nil {
                self.daoSindrome.removeSyndromeList(language: language)
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: true))
                completion()
            } else if hashLocal == nil {
                self.daoSindrome.createListOfSyndromes(language: language)
                self.updateLocalSyndromeList(language: language, hashRemote: hashRemote!,completion: {
                    self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: true))
                    completion()
                })
            } else if hashLocal!.caseInsensitiveCompare(hashRemote!) != ComparisonResult.orderedSame {
                self.updateLocalSyndromeList(language: language, hashRemote: hashRemote!,completion: {
                    self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: true))
                    completion()
                })
            } else {
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: false))
                completion()
            }
        })
    }
    
    private func updateLocalSyndromeList (language: String, hashRemote: String, completion: @escaping () -> Void) {
        let localSindromes = daoSindrome.getSyndromes(language: language).sorted(by: {$0.id < $1.id})
        wsSindrome.getSyndromes(language: language, completion: {(rSindromes) in
            guard rSindromes != nil else {
                completion()
                return
            }
            
            let remoteSindromes = rSindromes!.sorted(by: {$0.id! < $1.id!})
            var iterator: Int? = -1;
            for remote in remoteSindromes {
                iterator = self.removeLocalSyndromesUpToNextRemoteSyndrome(starting: iterator, localSindromes: localSindromes, remote: remote)
                
                var local : SindromeEntity? = nil
                
                if let it = iterator {
                    local = localSindromes[it]
                }
                
                if iterator == nil ||  local!.id > remote.id! {
                    self.daoSindrome.addSyndrome(sindrome: remote, language: language)
                } else if local!.id == remote.id! {
                    if local!.hashvalue?.caseInsensitiveCompare(remote.hash!) != ComparisonResult.orderedSame {
                        self.daoSindrome.updateSyndrome(syndrome: remote)
                    }
                }
            }
            self.daoSindrome.setHashForListOfSyndromes(language: language, hash: hashRemote)
            completion();
        })
    }
    
    private func removeLocalSyndromesUpToNextRemoteSyndrome(starting: Int?, localSindromes: [SindromeEntity], remote: Sindrome) -> Int? {
        var st = starting;
        if st != nil {
            var local : SindromeEntity?
            repeat {
                if st! < localSindromes.count-1 {
                    st = st! + 1
                    local = localSindromes[st!];
                    if local!.id < remote.id! {
                        daoSindrome.removeSyndrome(syndrome: local!);
                    }
                } else {
                    return nil
                }
            } while local!.id < remote.id!
            
            return st
        } else {
            return nil;
        }
    }
    
    
}
