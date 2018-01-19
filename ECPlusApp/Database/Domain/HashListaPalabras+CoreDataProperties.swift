//
//  HashListaPalabras+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension HashListaPalabras {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HashListaPalabras> {
        return NSFetchRequest<HashListaPalabras>(entityName: "HashListaPalabras")
    }

    @NSManaged public var resolucion: String?
    @NSManaged public var hashvalue: String?
    @NSManaged public var lista: ListaPalabras?

}
