//
//  ParseOperation.swift
//  VKDakhelOlga
//
//  Created by MacBook on 14/07/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ParseDataOperation : Operation {
    var users: [User] = []
    
    override func main() {
        guard let dataOperation = dependencies
            .filter({ $0 is FetchDataOperation})
            .first as? FetchDataOperation,
            let data = dataOperation.data else { return print ("No data loaded")}
        let json = try! JSON(data: data)
        let outputUsers:[User] = json["response"]["items"].arrayValue.map { User($0) }
        users = outputUsers
        
    }

}

