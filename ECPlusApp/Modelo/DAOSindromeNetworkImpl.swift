//
//  DAOSindromNetworkImpl.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 13/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class DAOSindromeNetworkImpl: DAOSindrome {

    let sindromeWS: WSSindrome = WSSindromeImpl();
    
    func createListOfSyndromes(language: String) {
        // TODO: no implementar
    }
    
    func getSyndromes(language: String, completion: @escaping ([Sindrome]) -> Void) {
        sindromeWS.getSyndromes(language: language, completion: completion);
    }
    
    func removeSyndromeList(language: String) {
        // TODO: no implementar
    }
    
    func getHashForListOfSyndromes(language: String, completion: @escaping (String?) -> Void) {
        sindromeWS.getHashForListOfSyndromes(language: language, completion: completion);
    }
    
    func setHashForListOfSyndromes(language: String, hash:String) {
        // TODO: no implementar
    }
    
    func removeSyndrome(syndrome: Sindrome) {
        // TODO: no implementar
    }
    
    func updateSyndrome(syndrome: Sindrome) {
        // TODO: no implementar
    }
    
    func addSyndrome(sindrome: Sindrome, language: String) {
        // TODO: no implementar
    }
}
