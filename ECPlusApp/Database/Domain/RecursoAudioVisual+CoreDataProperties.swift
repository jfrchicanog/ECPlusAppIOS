//
//  RecursoAudioVisual+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension RecursoAudioVisual {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecursoAudioVisual> {
        return NSFetchRequest<RecursoAudioVisual>(entityName: "RecursoAudioVisual")
    }

    @NSManaged public var id: Int32
    @NSManaged public var tipo: String?
    @NSManaged public var ficheros: NSSet?
    @NSManaged public var palabra: PalabraEntity?
    @NSManaged public var palabraIconada: PalabraEntity?

}

// MARK: Generated accessors for ficheros
extension RecursoAudioVisual {

    @objc(addFicherosObject:)
    @NSManaged public func addToFicheros(_ value: Fichero)

    @objc(removeFicherosObject:)
    @NSManaged public func removeFromFicheros(_ value: Fichero)

    @objc(addFicheros:)
    @NSManaged public func addToFicheros(_ values: NSSet)

    @objc(removeFicheros:)
    @NSManaged public func removeFromFicheros(_ values: NSSet)

}
