//
//  NetworkManager.swift
//  DirectMessaging
//
//  Created by Shrirang Kawade on 15/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import Foundation

class NetworkOperationManager {
    
    // MARK:- Properties
    lazy var webServiceRequestQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "webServiceRequest"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    // MARK:- Singleton Instance
    static let shared: NetworkOperationManager = {
        let singletonInstance = NetworkOperationManager()
        return singletonInstance
    }()
}
