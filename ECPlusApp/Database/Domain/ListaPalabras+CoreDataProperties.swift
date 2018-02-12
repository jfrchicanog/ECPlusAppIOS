//
//  ListaPalabras+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension ListaPalabras {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListaPalabras> {
        return NSFetchRequest<ListaPalabras>(entityName: "ListaPalabras")
    }

    @NSManaged public var idioma: String?
    @NSManaged public var id: Int32
    @NSManaged public var hashes: NSSet?
    @NSManaged public var categorias: NSSet?
    @NSManaged public var palabras: NSSet?

}

// MARK: Generated accessors for hashes
extension ListaPalabras {

    @objc(addHashesObject:)
    @NSManaged public func addToHashes(_ value: HashListaPalabras)

    @objc(removeHashesObject:)
    @NSManaged public func removeFromHashes(_ value: HashListaPalabras)

    @objc(addHashes:)
    @NSManaged public func addToHashes(_ values: NSSet)

    @objc(removeHashes:)
    @NSManaged public func removeFromHashes(_ values: NSSet)
    
    func getHash(for resolution: Resolution) -> HashListaPalabras? {
        if let hashSet = hashes {
            for h in hashSet {
                let hh = h as? HashListaPalabras
                if hh?.resolucion == resolution.rawValue {
                    return hh;
                }
            }
        }
        return nil;
    }

}

// MARK: Generated accessors for categorias
extension ListaPalabras {

    @objc(addCategoriasObject:)
    @NSManaged public func addToCategorias(_ value: Categoria)

    @objc(removeCategoriasObject:)
    @NSManaged public func removeFromCategorias(_ value: Categoria)

    @objc(addCategorias:)
    @NSManaged public func addToCategorias(_ values: NSSet)

    @objc(removeCategorias:)
    @NSManaged public func removeFromCategorias(_ values: NSSet)

}

// MARK: Generated accessors for palabras
extension ListaPalabras {

    @objc(addPalabrasObject:)
    @NSManaged public func addToPalabras(_ value: PalabraEntity)

    @objc(removePalabrasObject:)
    @NSManaged public func removeFromPalabras(_ value: PalabraEntity)

    @objc(addPalabras:)
    @NSManaged public func addToPalabras(_ values: NSSet)

    @objc(removePalabras:)
    @NSManaged public func removeFromPalabras(_ values: NSSet)

}
