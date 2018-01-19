//
//  PalabraEntity+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension PalabraEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PalabraEntity> {
        return NSFetchRequest<PalabraEntity>(entityName: "PalabraEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var nombre: String?
    @NSManaged public var avanzada: Bool
    @NSManaged public var iconoReemplazable: Bool
    @NSManaged public var iconoPersonalizado: String?
    @NSManaged public var lista: ListaPalabras?
    @NSManaged public var categoria: Categoria?
    @NSManaged public var contraria: PalabraEntity?
    @NSManaged public var icono: RecursoAudioVisual?
    @NSManaged public var recursos: NSSet?
    @NSManaged public var hashes: NSSet?
    @NSManaged public var uso: UsoPalabra?

}

// MARK: Generated accessors for recursos
extension PalabraEntity {

    @objc(addRecursosObject:)
    @NSManaged public func addToRecursos(_ value: RecursoAudioVisual)

    @objc(removeRecursosObject:)
    @NSManaged public func removeFromRecursos(_ value: RecursoAudioVisual)

    @objc(addRecursos:)
    @NSManaged public func addToRecursos(_ values: NSSet)

    @objc(removeRecursos:)
    @NSManaged public func removeFromRecursos(_ values: NSSet)

}

// MARK: Generated accessors for hashes
extension PalabraEntity {

    @objc(addHashesObject:)
    @NSManaged public func addToHashes(_ value: HashPalabra)

    @objc(removeHashesObject:)
    @NSManaged public func removeFromHashes(_ value: HashPalabra)

    @objc(addHashes:)
    @NSManaged public func addToHashes(_ values: NSSet)

    @objc(removeHashes:)
    @NSManaged public func removeFromHashes(_ values: NSSet)

}
