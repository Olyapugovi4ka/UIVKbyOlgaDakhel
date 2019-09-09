//
//  Account.swift
//  VKDakhelOlga
//
//  Created by MacBook on 17/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
class Account {

    public static let shared = Account()
    
    var token: String? = ""
    var userId: Int = 0
    var longPoll = LongPoll()
    
    var stringUserId: String {
        return String(userId)
    }
    
     private init() {}
    
    struct LongPoll {
        var server = ""
        var ts: TimeInterval = 0
        var pts: Int = 0
        var key = ""
    }
}
