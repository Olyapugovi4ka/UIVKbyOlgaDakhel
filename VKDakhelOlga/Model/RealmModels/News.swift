//
//  News.swift
//  VKDakhelOlga
//
//  Created by MacBook on 27/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


struct NewsResponse {
    let users:[User]
    let groups:[Group]
    let news:[News]
    let nextFrom:String
    
    
}

@objcMembers
class News: Object {
    
    //MARK: - Properties
    dynamic var postId: Int = -1
    dynamic var sourceId: Int = 0
    dynamic var newsText: String?
    dynamic var newsPhoto: Photo?
   // dynamic var date: Date?
      dynamic var date: Double = 0.0
    
    dynamic var likeCount: Int = 0
    dynamic var userLikes:Int = 0
    dynamic var commentsCount: Int = 0
    dynamic var repostsCount: Int = 0
    
    //MARK: - Initialisation
    convenience init(_ json: JSON){
        self.init()
        self.postId = json["post_id"].intValue
        self.sourceId = json["source_id"].intValue
        self.newsText = json["text"].stringValue
        let attachments = json["attachments"][0]["photo"]
        let photo = Photo.convert(attachments)
        self.newsPhoto = photo       
        self.date = json["date"].doubleValue
        
        self.likeCount = json["likes"]["count"].intValue
        self.userLikes = json["likes"]["user_likes"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
    }
    
    
    override static func primaryKey() -> String? {
        return "postId"
    }
}
