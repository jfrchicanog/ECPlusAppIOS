//
//  SindromeEntity+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension SindromeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SindromeEntity> {
        return NSFetchRequest<SindromeEntity>(entityName: "SindromeEntity")
    }

    @NSManaged public var nombre: String?
    @NSManaged public var contenido: String?
    @NSManaged public var id: Int32
    @NSManaged public var tipo: String?
    @NSManaged public var hashvalue: String?
    @NSManaged public var lista: ListaSindromes?

}
