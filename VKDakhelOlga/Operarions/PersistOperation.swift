//
//  PersistOperation.swift
//  VKDakhelOlga
//
//  Created by MacBook on 14/07/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import RealmSwift

class PersistDataOperation: Operation {
    
    override func main() {
        guard let parseOperation = dependencies
            .filter({ $0 is ParseDataOperation})
            .first as? ParseDataOperation else { return }
        
        try! RealmProvider.save(items: parseOperation.users)
        
    }
}
