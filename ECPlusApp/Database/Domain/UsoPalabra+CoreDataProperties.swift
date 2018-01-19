//
//  UsoPalabra+CoreDataProperties.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 19/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//
//

import Foundation
import CoreData


extension UsoPalabra {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsoPalabra> {
        return NSFetchRequest<UsoPalabra>(entityName: "UsoPalabra")
    }

    @NSManaged public var accesos: Int32
    @NSManaged public var ultimoAcceso: NSDate?
    @NSManaged public var palabra: PalabraEntity?

}
