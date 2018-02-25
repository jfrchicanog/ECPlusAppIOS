//
//  DatabaseUpdate.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class DatabaseUpdate {
    let daoSindrome : DAOSindrome = DAOFactory.getDAOSindrome()
    let daoPalabra : DAOPalabra = DAOFactory.getDAOPalabra()
    let wsSindrome : WSSindrome = WSSindromeImpl()
    let wsPalabra : WSPalabra = WSPalabraImpl()
    let updateServiceCoordinator = UpdateCoordinator.coordinator;
    let resourceStore : ResourceStore = ResourceStore()
    
    static var _databaseUpdate : DatabaseUpdate?
    
    static func getDatabaseUpdate() -> DatabaseUpdate {
        if _databaseUpdate == nil {
            _databaseUpdate = DatabaseUpdate()
        }
        return _databaseUpdate!
    }
    
    private init () {
    }
    
    func updatePalabras(language: String, resolution: Resolution) {
        self.updateServiceCoordinator.fireEvent(event: UpdateEvent.startUpdateWordsEvent())
        
        let hashLocal = daoPalabra.getHashForListOfWords(language: language, resolucion: resolution)
        wsPalabra.getHashForListOfWords(language: language, resolution: resolution, completion: {(hashRemote) in
            NSLog("Hash words: \(hashRemote!)")
            
            if hashRemote == nil {
                self.daoPalabra.removeAllResourcesForWordsList(language: language, resolution: resolution)
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsEvent(databaseChanged: true))
                
                self.removeUnusedFiles();
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsFileEvent(filesChanged: false));
                
            } else if hashLocal == nil || hashLocal!.caseInsensitiveCompare(hashRemote!) != ComparisonResult.orderedSame {
                if hashLocal == nil {
                    self.daoPalabra.createListOfWords(language: language)
                }
                self.updateLocalWordList(language: language, resolution: resolution, remoteHash: hashRemote!,completion: {
                    //self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsEvent(databaseChanged: true))
                    
                    self.removeUnusedFiles();
                    self.updateFiles(language: language, resolution: resolution);
                })
            } else {
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsEvent(databaseChanged: false))
            }
        })
    }
    
    func updateLocalWordList(language: String, resolution: Resolution, remoteHash: String, completion: @escaping () -> Void) {
        let localPalabras = daoPalabra.getWords(language: language, resolution: resolution)
            .sorted(by: {$0.id < $1.id})
        wsPalabra.getWords(language: language, resolution: resolution, completion: {(rPalabras) in
            let remotePalabras = rPalabras.sorted(by: {$0.id < $1.id})
            
            var localIterator : Int = 0
            var remoteIterator : Int = 0
            
            while (localIterator < localPalabras.count || remoteIterator  < remotePalabras.count) {
                if (localIterator >= localPalabras.count) {
                    NSLog("Adding \(remotePalabras[remoteIterator].id)")
                    self.daoPalabra.addWord(word: remotePalabras[remoteIterator], language: language, resolution: resolution)
                    remoteIterator = remoteIterator + 1
                } else if (remoteIterator >= remotePalabras.count) {
                    NSLog("Removing \(localPalabras[localIterator].id)")
                    self.daoPalabra.removeWord(word: localPalabras[localIterator])
                    localIterator = localIterator + 1
                } else if (localPalabras[localIterator].id > remotePalabras[remoteIterator].id) {
                    NSLog("Adding \(remotePalabras[remoteIterator].id)")
                    self.daoPalabra.addWord(word: remotePalabras[remoteIterator], language: language, resolution: resolution)
                    remoteIterator = remoteIterator + 1
                } else if (localPalabras[localIterator].id < remotePalabras[remoteIterator].id) {
                    NSLog("Removing \(localPalabras[localIterator].id)")
                    self.daoPalabra.removeWord(word: localPalabras[localIterator])
                    localIterator = localIterator + 1
                } else {
                    //if (localPalabras[localIterator].getHash(for: resolution)// TODO)
                    // TODO
                    
                    localIterator = localIterator + 1
                    remoteIterator = remoteIterator + 1
                }
            }
            self.daoPalabra.setHashForListOfWords(language: language, resolution: resolution, hash: remoteHash)
            completion();
        })
    }
    
    private func removeUnusedFiles() {
        // TODO
    }
    
    private func updateFiles(language: String, resolution: Resolution) {
        let palabras = daoPalabra.getWords(language: language, resolution: resolution)
        for palabra in palabras {
            if let recursos = palabra.recursos as? Set<RecursoAudioVisual> {
                for recurso in recursos {
                    if let fichero = recurso.getFichero(for: resolution) {
                        if (!resourceStore.fileExists(withHash: fichero.hashvalue!)) {
                            wsPalabra.getResource(hash: fichero.hashvalue!, toFile: resourceStore.getFileResource(for: fichero.hashvalue!))
                        }
                    }
                }
            }
        }
        self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateWordsFileEvent(filesChanged: true));
        // TODO
    }
    
    func updateSindromes(language: String) {
        self.updateServiceCoordinator.fireEvent(event: UpdateEvent.startUpdateSyndromesEvent())
        let hashLocal = daoSindrome.getHashForListOfSyndromes(language: language)
        wsSindrome.getHashForListOfSyndromes(language: language, completion: {(hashRemote) in
            if hashRemote == nil {
                self.daoSindrome.removeSyndromeList(language: language)
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: true))
            } else if hashLocal == nil || hashLocal!.caseInsensitiveCompare(hashRemote!) != ComparisonResult.orderedSame {
                if hashLocal == nil {
                    self.daoSindrome.createListOfSyndromes(language: language)
                }
                self.updateLocalSyndromeList(language: language, hashRemote: hashRemote!,completion: {
                    self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: true))
                })
            } else {
                self.updateServiceCoordinator.fireEvent(event: UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: false))
            }
        })
    }
    
    private func updateLocalSyndromeList (language: String, hashRemote: String, completion: @escaping () -> Void) {
        let localSindromes = daoSindrome.getSyndromes(language: language).sorted(by: {$0.id < $1.id})
        wsSindrome.getSyndromes(language: language, completion: {(rSindromes) in
            let remoteSindromes = rSindromes.sorted(by: {$0.id! < $1.id!})
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
