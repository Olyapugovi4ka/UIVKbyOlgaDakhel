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
    dynamic var likeCount: Int = 0
    dynamic var commentsCount: Int = 0
    
    convenience init(_ json: JSON){
        self.init()
       // print(json)
        self.postId = json["post_id"].intValue
        self.sourceId = json["source_id"].intValue
        self.newsText = json["text"].stringValue
        let attachments = json["attachments"][0]["photo"]
        print(attachments)
        let photo = Photo.convert(attachments)
        self.newsPhoto = photo
       // let photo = attachments[0]
       // print(photo)
        //self.newsPhoto = json["attachments"][0]["photo"].arrayValue.map {Photo ($0)}
//            .filter { json -> Bool in
//            return json["type"].stringValue == "photo" }
            //.map { Photo($0["photo"])}
        //["type"].stringValue
    //    print(attachments)
//        guard let photo = attachments.filter { json in
//            return
//        }
//        self.newsPhoto = attahments.arrayValue
//            .filter { json -> Bool in
//            return json["type"] == "photo"}
//        .["photo"].arrayValue.map { Photo($0)}
        //print(self.newsPhoto?.count)
        
        self.likeCount = json["likes"]["count"].intValue
        self.commentsCount = json["coments"]["count"].intValue
    }
    
    
    override static func primaryKey() -> String? {
        return "postId"
    }
}
