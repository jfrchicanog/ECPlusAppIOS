//
//  Sindrome.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 26/10/17.
//  Copyright © 2017 José Francisco Chicano García. All rights reserved.
//

import Foundation

class Sindrome {
    var id: Int?
    var nombre: String?
    var contenido: String?
    var hash: String?
    var tipo: String?
    
    init(id: Int?, nombre: String?, contenido: String?, hash: String?, tipo: String?) {
        self.id=id;
        self.nombre = nombre;
        self.contenido = contenido;
        self.hash = hash;
        self.tipo = tipo;
    }
    
    init(jsonDictionary: NSDictionary){
        nombre = jsonDictionary.object(forKey: "nombre") as! String?;
        id = jsonDictionary.object(forKey: "id") as! Int?;
        hash = jsonDictionary.object(forKey: "hash") as! String?;
        tipo = jsonDictionary.object(forKey: "tipo") as! String?;
        let contenidoString = jsonDictionary.object (forKey: "contenido") as! String;
        let datos = NSData(base64Encoded: contenidoString);
        self.contenido = String(data: (datos as Data?)!, encoding: .utf8);
    }
}
