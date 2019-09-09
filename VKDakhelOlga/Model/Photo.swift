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
    @objc dynamic var albumId:Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var numberOfLikes: Int = 0
    @objc dynamic var height: Double = 0
    @objc dynamic var width: Double = 0
    var aspectRatio: Double? {
        guard height != 0 else { return nil }
        return Double(width)/Double(height)
    }
    
    let owner = LinkingObjects(fromType: User.self, property: "photos")
    
    static func convert(_ json: JSON) -> Photo {
       
        let photo = Photo()
        
        photo.photoId = json["id"].intValue
        photo.albumId = json["album_id"].intValue
        photo.userId = json["owner_id"].intValue
        photo.text = json["text"].stringValue
        photo.date = json["date"].intValue
        photo.name = json["sizes"][3]["url"].stringValue
        photo.height = json["sizes"][3]["height"].doubleValue
        photo.width = json["sizes"][3]["width"].doubleValue
        return photo
    }
    
    //MARK: - Initialisation
    convenience init(_ json: JSON){
        self.init()
        print(json)
        self.photoId = json["id"].intValue
        self.userId = json["owner_id"].intValue
        self.name = json["sizes"][3]["url"].stringValue
        print(self.name)
        self.numberOfLikes = json["likes"]["count"].intValue
        self.height = json["sizes"][3]["height"].doubleValue
        self.width = json["sizes"][3]["width"].doubleValue
        
    }
        
    override static func primaryKey() -> String? {
        return "photoId"
    }
}
