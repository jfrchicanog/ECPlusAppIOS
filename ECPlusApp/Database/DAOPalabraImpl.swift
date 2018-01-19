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
    
    func getHashForListOfWords(language: String, resolucion: Resolution) -> String {
        <#code#>
    }
    
    func removeAllResourcesForWordsList(language: String, resolution: Resolution) {
        <#code#>
    }
    
    func createListOfWords(language: String) {
        <#code#>
    }
    
    func getWords(language: String, resolution: Resolution) -> [PalabraEntity] {
        <#code#>
    }
    
    func addWord(word: Palabra, language: String, resolution: Resolution) {
        <#code#>
    }
    
    func updateWord(remote: Palabra) {
        <#code#>
    }
    
    func updateUso(palabra: PalabraEntity) {
        <#code#>
    }
    
    func setHashForListOfWords(language: String, resolution: Resolution, hash: String) {
        <#code#>
    }
    
    func removeWord(word: PalabraEntity) {
        <#code#>
    }
    
    func getAllHashes() -> [String] {
        <#code#>
    }
    
    
}
