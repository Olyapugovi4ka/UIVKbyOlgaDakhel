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

@objcMembers
class News: Object {
    
    dynamic var postId: Int = 0
    dynamic var sourceId: Int = 0
    dynamic var newsText: String = ""
    //dynamic var newsPhoto: Photo?
    //dynamic var likeCount: Int = 0
   // dynamic var commentsCount: Int = 0
    
    convenience init(_ json: JSON){
        self.init()
        self.postId = json["post_id"].intValue
        self.sourceId = json["source_id"].intValue
        self.newsText = json["text"].stringValue
        //self.newsPhoto = json[]
        //self.likeCount = json[]
       // self.commentsCount = json[]
    }
        
        
    override static func primaryKey() -> String? {
        return "postId"
    }
}
//"response": {
//    "items": [
//    {
//    "type": "post",
//    "source_id": -34215577,
//    "date": 1561283406,
//    "post_type": "post",
//    "text": "Голова — мое травмоопасное место. В 5 лет мне упал на голову силикатный кирпич с трёхметровой высоты, в 6 мне ударили лопатой с потерей сознания, в 7 удар головой о чугунную батарею, в 9 пробил голову о стальной уголок, и ещё много травм. Мне в детстве говорили, что это вылезет с возрастом. Уже пятый десяток, а все, вроде, ничего. Голова чугунная или мне просто не говорят, что я идиот уже…",
//    "marked_as_ads": 0,
//    "post_source": {
//    "type": "api"
//    },
//    "comments": {
//    "count": 0,
//    "can_post": 0,
//    "groups_can_post": true
//    },
//    "likes": {
//    "count": 16,
//    "user_likes": 0,
//    "can_like": 1,
//    "can_publish": 1
//    },
//    "reposts": {
//    "count": 0,
//    "user_reposted": 0
//    },
//    "views": {
//    "count": 1084
//    },
//    "is_favorite": false,
//    "post_id": 1188202
//    },
