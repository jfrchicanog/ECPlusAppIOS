//
//  DAOPalabra.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import CoreData

protocol DAOPalabra {
    func getHashForListOfWords(language: String, resolucion: Resolution) -> String?
    func removeAllResourcesForWordsList(language: String, resolution: Resolution)
    func createListOfWords(language: String)
    func getWords(language: String, resolution: Resolution) -> [PalabraEntity]
    func getWords(language: String, context: NSManagedObjectContext) -> [PalabraEntity]
    func getCategorias(language: String, context: NSManagedObjectContext) -> [Categoria]
    func addWord(context: NSManagedObjectContext, word: Palabra, categoria: Categoria?, language: String, resolution: Resolution)
    func updateWord(context: NSManagedObjectContext, local: PalabraEntity, remote: Palabra, categoria: Categoria?, resolution: Resolution)
    func updateUso(palabra: PalabraEntity);
    func setHashForListOfWords(context: NSManagedObjectContext, language: String, resolution: Resolution, hash: String)
    func removeWord(context: NSManagedObjectContext, word: PalabraEntity)
    func getAllHashes() -> [String]
    func save()
    func getListOfWords(context: NSManagedObjectContext, language: String) throws -> ListaPalabras?
}
