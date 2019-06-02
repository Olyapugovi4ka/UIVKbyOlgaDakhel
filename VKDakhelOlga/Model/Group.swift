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

class Group: Object {
    
    //MARK: - Properties
   @objc dynamic var name: String = ""
  @objc dynamic  var avatarName: String?
    
    //MARK: - Initialisation
    convenience init(_ json:JSON){
        self.init()
        self.name = json["name"].stringValue
        self.avatarName = json["photo_200"].stringValue
    }
}

