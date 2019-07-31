//
//  Photo.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object{
    
    //MARK: - Properties
    @objc dynamic var photoId:Int = -1
    @objc dynamic var userId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var numberOfLikes: Int = 0
    @objc dynamic var height: Double = 0
    @objc dynamic var width: Double = 0
    var aspectRatio: Double {
        return width/height
    }
    
    let owner = LinkingObjects(fromType: User.self, property: "photos")
    
    //MARK: - Initialisation
    convenience init(_ json: JSON){
        self.init()
        print(json)
        self.photoId = json["id"].intValue
        self.userId = json["owner_id"].intValue
        self.name = json["sizes"][3]["url"].stringValue
        self.numberOfLikes = json["likes"]["count"].intValue
        self.height = json["sizes"][3]["height"].doubleValue
        self.width = json["sizes"][3]["width"].doubleValue
        
    }
        
    override static func primaryKey() -> String? {
        return "photoId"
    }
}
