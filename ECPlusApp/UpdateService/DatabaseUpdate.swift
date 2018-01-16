//
//  DatabaseUpdate.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class DatabaseUpdate {
    let daoSindrome = DAOSindromeDatabase()
    let wsSindrome = WSSindromeImpl()
    
    static var _databaseUpdate : DatabaseUpdate?
    
    func updateSindromes(language: String, listener: @escaping (UpdateEvent) -> Void ) -> Void {
        listener(UpdateEvent.startUpdateSyndromesEvent())
        let hashLocal = daoSindrome.getHashForListOfSyndromes(language: language)
        wsSindrome.getHashForListOfSyndromes(language: language, completion: {(hashRemote) in
            if hashRemote == nil {
                self.daoSindrome.removeSyndromeList(language: language)
                listener(UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: true))
            } else if hashLocal == nil || hashLocal!.caseInsensitiveCompare(hashRemote!) != ComparisonResult.orderedSame {
                if hashLocal == nil {
                    self.daoSindrome.createListOfSyndromes(language: language)
                }
                self.updateLocalSyndromeList(language: language, hashRemote: hashRemote!,completion: {
                    listener(UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: true))
                })
            } else {
                listener(UpdateEvent.stopUpdateSyndromesEvent(databaseChanged: false))
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
    
    static func getDatabaseUpdate() -> DatabaseUpdate {
        if _databaseUpdate == nil {
            _databaseUpdate = DatabaseUpdate()
        }
        return _databaseUpdate!
    }
}
