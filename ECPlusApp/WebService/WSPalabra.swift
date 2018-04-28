//
//  WSPalabra.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 17/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

enum Resolution: String {
    case baja = "BAJA"
    case media = "MEDIA"
    case alta = "ALTA"
}

protocol WSPalabra {
    func getHashForListOfWords(language: String, resolution: Resolution, completion: @escaping (String?)->Void)
    func getWords(language: String, resolution: Resolution, completion: @escaping ([Palabra])->Void)
    func getResource(hash: String, toFile: URL)
    func getCategories(language: String, completion: @escaping ([CategoriaREST]) -> Void)
}


