//
//  CategoriaREST.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 23/3/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class CategoriaREST {
    var id: Int32
    var nombre: String?
    
    init (id: Int32, nombre: String?) {
        self.id = id
        self.nombre = nombre
    }
    
    init(jsonDictionary: NSDictionary) {
        nombre = jsonDictionary.object(forKey: "nombre") as! String?;
        id = jsonDictionary.object(forKey: "id") as! Int32;
    }
    
}
