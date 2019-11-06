//
//  Friend.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers
class User: Object{
    
    //MARK: - Properties
    dynamic var userId: Int = -1
    dynamic var userName:String = ""
    dynamic var avatarName: String = ""
    
    var photos = List<Photo>()
    
    //MARK: - Initialisation
    convenience init(_ json: JSON){
        self.init()
        self.userId = json["id"].intValue
        self.userName = (json["first_name"].stringValue + " " + json["last_name"].stringValue)
        self.avatarName = json["photo_200_orig"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
