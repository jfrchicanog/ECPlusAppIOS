//
//  WSSindromeImple.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 13/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class WSSindromeImpl: WSSindrome {
    let host = "https://ecplusproject.uma.es"
    let apiEndPoint = "/academicPortal/ecplus/api/v1"
    let sindromesPath = "/sindromes"
    let hashSuffix = "/hash"
    
    func getSyndromes(language: String, completion: @escaping ([Sindrome]) -> Void) {
        var peticion = URLRequest(url: NSURL(string: host + apiEndPoint + sindromesPath + "/" + language)! as URL)
        
        peticion.addValue("application/json", forHTTPHeaderField: "Accept");
        peticion.httpMethod="GET"
        
        let session = URLSession.shared;
        var listaSindromes:[Sindrome] = [];
        let dataTask = session.dataTask(with: peticion, completionHandler:
        {(datos: Data?, respuesta: URLResponse?, error: Error?) in
            
            let object = try! JSONSerialization.jsonObject(with: datos!)
            
            let lista = object as! NSArray;
            for elemento in lista {
                let diccionario = elemento as! NSDictionary;
                listaSindromes.append(Sindrome(jsonDictionary: diccionario));
            }
            completion(listaSindromes);
        })
        dataTask.resume();
    }
    
    func getHashForListOfSyndromes(language: String, completion: @escaping (String?) -> Void) {
        var peticion = URLRequest(url: NSURL(string: host + apiEndPoint + sindromesPath + "/" + language + hashSuffix )! as URL)
        
        peticion.addValue("application/json", forHTTPHeaderField: "Accept");
        peticion.httpMethod="GET"
        
        let session = URLSession.shared;
        let dataTask = session.dataTask(with: peticion, completionHandler:
        {(datos: Data?, respuesta: URLResponse?, error: Error?) in
            
            let object = try! JSONSerialization.jsonObject(with: datos!)
            let hashContainer = object as! NSDictionary;
            completion(hashContainer.object(forKey: "hash") as! String?);
        })
        dataTask.resume();
    }
}
