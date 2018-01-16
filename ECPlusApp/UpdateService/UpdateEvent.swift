//
//  UpdateEvent.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

enum UpdateEventAction : String {
    case start = "start"
    case stopDatabase = "stopDatabase"
    case stopFile = "stopFile"
    case stopError = "stopError"
}

enum UpdateEventElement : String {
    case syndromes = "syndromes"
    case words = "words"
}

class UpdateEvent: NSObject {
    var action : UpdateEventAction?
    var element : UpdateEventElement?
    var somethingChanged : Bool?
    
    init(action: UpdateEventAction?, element: UpdateEventElement?, somethingChanged: Bool?) {
        self.action = action;
        self.element = element;
        self.somethingChanged = somethingChanged;
    }
   
    static func startUpdateSyndromesEvent() -> UpdateEvent {
        return UpdateEvent(action: UpdateEventAction.start, element: UpdateEventElement.syndromes, somethingChanged: nil)
    }
    
    static func stopUpdateSyndromesEvent(databaseChanged: Bool) -> UpdateEvent {
        return UpdateEvent(action: UpdateEventAction.stopDatabase, element: UpdateEventElement.syndromes, somethingChanged: databaseChanged)
    }
    
    static func stopUpdateSyndromesError() -> UpdateEvent {
        return UpdateEvent(action: UpdateEventAction.stopError, element: UpdateEventElement.syndromes, somethingChanged: false)
    }
    
    func description() -> String {
        return (action?.rawValue)!+","+(element?.rawValue)!+",\(somethingChanged)"
    }
}
