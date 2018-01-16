//
//  UpdateCoordinator.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

protocol UpdateServiceListener {
    func onUpdateEvent (event: UpdateEvent);
}

class UpdateCoordinator {
    static var coordinator : UpdateCoordinator = {
        return UpdateCoordinator()
    }()
    
    private init() {
    }
    
    private var listeners : [UpdateServiceListener] = []
    
    func addListener(listener: UpdateServiceListener) {
        listeners.append(listener)
    }
    
    func fireEvent(event: UpdateEvent) {
        for listener in listeners {
            listener.onUpdateEvent(event: event)
        }
    }

}
