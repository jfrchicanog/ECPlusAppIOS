//
//  DAOSindromeDatabase.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation
import CoreData

class DAOSindromeDatabase: DAOSindrome {
    
    func createListOfSyndromes(language: String) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait ({
            do {
                let listas = try self.getSyndromeLists(context: context, language: language)
                if listas.isEmpty {
                    let listaSindromes = NSEntityDescription.insertNewObject(forEntityName: "ListaSindromes", into: context) as! ListaSindromes;
                    listaSindromes.idioma = language;
                    listaSindromes.id = 0;
                    try context.save()
                    
                }
            } catch {
                fatalError("Failed to fetch employees: \(error)")
            }
        })
    }
    
    private func getSyndromeLists(context: NSManagedObjectContext, language: String) throws ->  [ListaSindromes] {
        let listaFetch = NSFetchRequest<ListaSindromes>(entityName: "ListaSindromes")
        listaFetch.predicate = NSPredicate(format: "idioma = '\(language)'");
        return try context.fetch(listaFetch);
    }
    
    func getSyndromes(language: String) -> [SindromeEntity] {
        do {
            let listas = try self.getSyndromeLists(context: DataController.dataController.mainQueueContext, language: language)
            if listas.isEmpty {
                return  [];
            } else {
                let conjunto = listas.last?.sindromes;
                return Array(conjunto!) as! [SindromeEntity]
            }
        } catch {
            fatalError("Failed to get Syndromes: \(error)")
        }
    }
    
    func removeSyndromeList(language: String) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait {
            do {
                let listas = try self.getSyndromeLists(context: context, language: language)
                for elemento in listas {
                    context.delete(elemento)
                }
                try context.save()
            } catch {
                fatalError("Failed to remove lists of Syndromes: \(error)")
            }
        }
    }
    
    func getHashForListOfSyndromes(language: String) -> String? {
        let context = DataController.dataController.getPrivateQueueContext();
        var result : String? = nil;
        context.performAndWait {
            do {
                let listas = try self.getSyndromeLists(context: context, language: language)
                result = listas.last?.hashvalue
            } catch {
                fatalError("Failed to get hash for List of Syndromes: \(error)")
            }
        }
        return result;
    }
    
    func setHashForListOfSyndromes(language: String, hash:String) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait {
            do {
                let listas = try self.getSyndromeLists(context: context, language: language)
                listas.last!.hashvalue = hash
                try context.save()
            } catch {
                fatalError("Failed to set hash for List of Syndromes: \(error)")
            }
        }
    }
    
    func removeSyndrome(syndrome: SindromeEntity) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait {
            do {
                context.delete(syndrome)
                try context.save()
            } catch {
                fatalError("Failed to delete syndrome: \(error)")
            }
        }
    }
    
    func updateSyndrome(syndrome: Sindrome) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait {
            do {
                let sindromeFetch = NSFetchRequest<SindromeEntity>(entityName: "SindromeEntity")
                sindromeFetch.predicate = NSPredicate(format: "id = \(syndrome.id!)");
                if let sindrome = try context.fetch(sindromeFetch).last {
                    sindrome.contenido = syndrome.contenido
                    sindrome.hashvalue = syndrome.hash
                    sindrome.nombre = syndrome.nombre
                    sindrome.tipo = syndrome.tipo!.rawValue
                    try context.save()
                }
            } catch {
                fatalError("Failed to delete syndrome: \(error)")
            }
        }
    }
    
    func addSyndrome(sindrome: Sindrome, language: String) {
        let context = DataController.dataController.getPrivateQueueContext()
        context.performAndWait {
            do {
                let sindromeEntity = NSEntityDescription.insertNewObject(forEntityName: "SindromeEntity", into: context) as! SindromeEntity;
                sindromeEntity.id = Int32(sindrome.id!);
                sindromeEntity.contenido = sindrome.contenido
                sindromeEntity.hashvalue = sindrome.hash
                sindromeEntity.nombre = sindrome.nombre
                sindromeEntity.tipo = sindrome.tipo?.rawValue
                
                let listas = try self.getSyndromeLists(context: context, language: language)
                listas.last?.addToSindromes(sindromeEntity)
                try context.save()
            } catch {
                fatalError("Failed to add Syndrome: \(error)")
            }
        }
    }
}
