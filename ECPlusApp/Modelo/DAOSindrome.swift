//
//  DAOSindrome.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 13/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

protocol DAOSindrome {
    func createListOfSyndromes(language: String);
    func getSyndromes(language: String, completion: @escaping ([Sindrome]) -> Void);
    func removeSyndromeList(language: String);
    func getHashForListOfSyndromes(language: String) -> String?;
    func setHashForListOfSyndromes(language: String, hash:String);
    
    func removeSyndrome(syndrome: Sindrome);
    func updateSyndrome(syndrome: Sindrome);
    func addSyndrome(sindrome: Sindrome, language: String);
}
