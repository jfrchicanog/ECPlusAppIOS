//
//  ListaSindromes+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension ListaSindromes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListaSindromes> {
        return NSFetchRequest<ListaSindromes>(entityName: "ListaSindromes")
    }

    @NSManaged public var idioma: String?
    @NSManaged public var hashvalue: String?
    @NSManaged public var id: Int32
    @NSManaged public var sindromes: NSSet?

}

// MARK: Generated accessors for sindromes
extension ListaSindromes {

    @objc(addSindromesObject:)
    @NSManaged public func addToSindromes(_ value: SindromeEntity)

    @objc(removeSindromesObject:)
    @NSManaged public func removeFromSindromes(_ value: SindromeEntity)

    @objc(addSindromes:)
    @NSManaged public func addToSindromes(_ values: NSSet)

    @objc(removeSindromes:)
    @NSManaged public func removeFromSindromes(_ values: NSSet)

}
