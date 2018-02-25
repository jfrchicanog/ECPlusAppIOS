//
//  DAOPalabra.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

protocol DAOPalabra {
    func getHashForListOfWords(language: String, resolucion: Resolution) -> String?
    func removeAllResourcesForWordsList(language: String, resolution: Resolution)
    func createListOfWords(language: String)
    func getWords(language: String, resolution: Resolution) -> [PalabraEntity]
    func addWord(word: Palabra, language: String, resolution: Resolution)
    func updateWord(remote: Palabra)
    func updateUso(palabra: PalabraEntity);
    func setHashForListOfWords(language: String, resolution: Resolution, hash: String)
    func removeWord(word: PalabraEntity)
    func getAllHashes() -> [String]
    func save()
}
