//
//  OperationManager.swift
//  VKDakhelOlga
//
//  Created by MacBook on 10/07/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation

class OperationsManager{
    lazy var operationsInProgress = [IndexPath:Operation]()
    lazy var filteringQ: OperationQueue = {
        var q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        q.name = name
        q.qualityOfService = .userInitiated
        return q
    }()
    let name: String
    init(name: String) {
        self.name = name
    }
    
}
