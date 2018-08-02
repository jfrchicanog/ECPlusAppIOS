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
    
    private var networkActivity: Int = 0
    private var globalUpdateInProgress : Bool = false
    
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
    
    func increaseNetworkActivity() {
        networkActivity += 1;
        if (networkActivity == 1) {
            fireEvent(event: UpdateEvent.startNetworkEvent())
            OperationQueue.main.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            }
        }
    }
    
    func decreaseNetworkActivity() {
        networkActivity -= 1;
        if (networkActivity <= 0) {
            fireEvent(event: UpdateEvent.stopNetworkEvent())
            OperationQueue.main.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            }
            
        }
    }
    
    func isThereNetworkActivity() -> Bool {
        return networkActivity > 0;
    }
    
    func startGlobalUpdate() {
        globalUpdateInProgress = true
        UpdateCoordinator.coordinator.fireEvent(event: UpdateEvent.startGlobalUpdateEvent())
    }
    
    func stopGlobalUpdate() {
        globalUpdateInProgress = false
        UpdateCoordinator.coordinator.fireEvent(event: UpdateEvent.stopGlobalUpdateEvent())
    }
    
    func thereIsGlobalUpdateInProgress() -> Bool {
        return globalUpdateInProgress
    }

}
