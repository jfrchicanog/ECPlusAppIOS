//
//  DAOSindromNetworkImpl.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 13/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

class DAOSindromeNetworkImpl: DAOSindrome {

    let host = "https://ecplusproject.uma.es"
    let apiEndPoint = "/academicPortal/ecplus/api/v1"
    let sindromesPath = "/sindromes"
    
    
    func createListOfSyndromes(language: String) {
        // TODO: no implementar
    }
    
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
    
    func removeSyndromeList(language: String) {
        // TODO: no implementar
    }
    
    func getHashForListOfSyndromes(language: String) -> String? {
        // TODO: no implementar por el momento
        return nil;
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
