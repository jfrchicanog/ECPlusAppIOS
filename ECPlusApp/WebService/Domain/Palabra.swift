//
//  Palabra.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 17/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

enum TipoRecurso: String {
    case pictograma = "Pictograma"
    case foto = "Fotografia"
    case video = "Video"
    case audio = "Audio"
}

class RecursoAudioVisualWS : Hashable {
    var hashValue: Int
    
    static func ==(lhs: RecursoAudioVisualWS, rhs: RecursoAudioVisualWS) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id : Int32;
    var type : TipoRecurso?;
    var hash : String?;
    
    init(id: Int32, type: TipoRecurso?, hash: String?) {
        self.id = id;
        self.type = type;
        self.hash = hash;
        self.hashValue = Int(id);
    }
    
    init(jsonDictionary: NSDictionary) {
        id = jsonDictionary.object(forKey: "id") as! Int32;
        hash = jsonDictionary.object(forKey: "hash") as? String;
        let stype = jsonDictionary.object(forKey: "type") as? String;
        if let tipo = stype {
            switch (tipo) {
            case "Pictograma":
                type = .pictograma
            case "Video":
                type = .video
            case "Fotografia":
                type = .foto
            case "Audio":
                type = .audio
            default:
                type = nil
            }
        }
        hashValue = Int(id)
    }
}

class Palabra {
    var id : Int32;
    var nombre : String?;
    var iconoReemplazable : Bool?;
    var hash : String?;
    var audiovisuales : Set<RecursoAudioVisualWS>
    var icono : Int32?
    var iconoReemplazado : String?
    var avanzada : Bool?
    
    init(id: Int32) {
        self.id = id;
        audiovisuales = Set<RecursoAudioVisualWS>()
    }
    
    init (jsonDictionary: NSDictionary) {
        id = jsonDictionary.object(forKey: "id") as! Int32;
        nombre = jsonDictionary.object(forKey: "nombre") as? String;
        iconoReemplazable = jsonDictionary.object(forKey: "iconoReemplazable") as? Bool;
        hash = jsonDictionary.object(forKey: "hash") as? String;
        icono = jsonDictionary.object(forKey: "icono") as? Int32
        iconoReemplazado = jsonDictionary.object(forKey: "iconoReemplazado") as? String
        avanzada = jsonDictionary.object(forKey: "avanzada") as? Bool
        
        let listaAV = jsonDictionary.object(forKey: "audiovisuales") as! NSArray
        audiovisuales = Set<RecursoAudioVisualWS>()
        for av in listaAV {
            audiovisuales.insert(RecursoAudioVisualWS(jsonDictionary: av as! NSDictionary))
        }
    }
    
    
}
