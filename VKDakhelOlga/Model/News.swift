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
    
    
}

@objcMembers
class News: Object {
    
    dynamic var postId: Int = 0
    dynamic var sourceId: Int = 0
    dynamic var newsText: String?
    dynamic var newsPhoto: Photo?
    //dynamic var likeCount: Int = 0
   // dynamic var commentsCount: Int = 0
    
    convenience init(_ json: JSON){
        self.init()
        print(json)
        self.postId = json["post_id"].intValue
        // print(self.postId)
        self.sourceId = json["source_id"].intValue
        //print(self.sourceId)
        self.newsText = json["text"].stringValue
        // print(self.newsText)
        let attahments = json["attachments"][].arrayValue
        let photo = attahments.filter { json -> Bool in
            return json["type"] == "photo"
            }.map { Photo($0["photo"])}
        print(photo.count)
        
        //self.likeCount = json[]
       // self.commentsCount = json[]
    }
        
        
    override static func primaryKey() -> String? {
        return "postId"
    }
}
