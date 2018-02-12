//
//  WSPalabraImpl.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 17/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class WSPalabraImpl: WSPalabra {
    let host = "https://ecplusproject.uma.es"
    let apiEndPoint = "/academicPortal/ecplus/api/v1"
    let resourcePath = "/resource"
    let palabrasPath = "/words"
    let hashSuffix = "/hash"
    
    
    func getHashForListOfWords(language: String, resolution: Resolution, completion: @escaping (String?) -> Void) {
        var peticion = URLRequest(url: NSURL(string: host + apiEndPoint + palabrasPath + "/" + language + hashSuffix )! as URL)
        
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
    
    func getWords(language: String, resolution: Resolution, completion: @escaping ([Palabra]) -> Void) {
        var peticion = URLRequest(url: NSURL(string: host + apiEndPoint + palabrasPath + "/" + language)! as URL)
        
        peticion.addValue("application/json", forHTTPHeaderField: "Accept");
        peticion.httpMethod="GET"
        
        let session = URLSession.shared;
        var listaPalabras:[Palabra] = [];
        let dataTask = session.dataTask(with: peticion, completionHandler:
        {(datos: Data?, respuesta: URLResponse?, error: Error?) in
            
            let object = try! JSONSerialization.jsonObject(with: datos!)
            
            let lista = object as! NSArray;
            for elemento in lista {
                let diccionario = elemento as! NSDictionary;
                listaPalabras.append(Palabra(jsonDictionary: diccionario));
            }
            completion(listaPalabras);
        })
        dataTask.resume();
    }
    
    func getResource(hash: String, toFile: URL) {
        var peticion = URLRequest(url: NSURL(string: host + apiEndPoint + resourcePath + "/" + hash)! as URL)
        peticion.addValue("*/*", forHTTPHeaderField: "Accept");
        peticion.httpMethod="GET"
        
        let session = URLSession.shared;
        let dataTask = session.dataTask(with: peticion, completionHandler:
        {(datos: Data?, respuesta: URLResponse?, error: Error?) in
            do {
                try datos?.write(to: toFile)
            } catch {
                NSLog("Error downloading file \(error)")
            }
        })
        dataTask.resume();
    }
    
    
}
