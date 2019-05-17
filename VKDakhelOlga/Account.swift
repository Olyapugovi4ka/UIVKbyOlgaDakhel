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
    var token: String?
    var userId: Int?
    private init() {}
    
}
