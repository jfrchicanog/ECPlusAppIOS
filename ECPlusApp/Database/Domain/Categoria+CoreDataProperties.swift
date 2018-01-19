//
//  Categoria+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension Categoria {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categoria> {
        return NSFetchRequest<Categoria>(entityName: "Categoria")
    }

    @NSManaged public var id: Int32
    @NSManaged public var nombre: String?
    @NSManaged public var lista: ListaPalabras?
    @NSManaged public var palabras: NSSet?

}

// MARK: Generated accessors for palabras
extension Categoria {

    @objc(addPalabrasObject:)
    @NSManaged public func addToPalabras(_ value: PalabraEntity)

    @objc(removePalabrasObject:)
    @NSManaged public func removeFromPalabras(_ value: PalabraEntity)

    @objc(addPalabras:)
    @NSManaged public func addToPalabras(_ values: NSSet)

    @objc(removePalabras:)
    @NSManaged public func removeFromPalabras(_ values: NSSet)

}
