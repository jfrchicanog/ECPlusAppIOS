//
//  DataController.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import UIKit
import CoreData
class DataController {
    static var context : NSManagedObjectContext = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext;
    }()
}
