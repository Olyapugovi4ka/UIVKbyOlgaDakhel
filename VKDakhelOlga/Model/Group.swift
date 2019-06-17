//
//  File.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers
class Group: Object {
    
    //MARK: - Properties
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic  var avatarName: String?
    
    //MARK: - Initialisation
    convenience init(_ json:JSON){
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.avatarName = json["photo_200"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

