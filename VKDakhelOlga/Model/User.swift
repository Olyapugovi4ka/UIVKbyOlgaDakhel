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

class User: Object{
    
    //MARK: - Properties
    @objc dynamic var userId: Int = 0
    @objc dynamic var userName:String = ""
    @objc dynamic var avatarName: String = ""
    @objc dynamic var photos: [Photo]?
    
    //MARK: - Initialisation
   convenience init(_ json: JSON){
    self.init()
        self.userId = json["id"].intValue
        self.userName = (json["first_name"].stringValue + " " + json["last_name"].stringValue)
        self.avatarName = json["photo_200_orig"].stringValue
    }
}
