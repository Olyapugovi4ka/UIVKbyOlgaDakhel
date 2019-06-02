//
//  Friend.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    //MARK: - Properties
    let userId: Int
    let userName:String
    let avatarName: String
    var photos: [Photo]?
    
    //MARK: - Initialisation
    init(_ json: JSON){
        self.userId = json["id"].intValue
        self.userName = (json["first_name"].stringValue + " " + json["last_name"].stringValue)
        self.avatarName = json["photo_200_orig"].stringValue
    }
}
