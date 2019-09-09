//
//  Chat.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/08/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON
import MessageKit
import RealmSwift

struct Chat {
    let id: Int
    let avatarUrl: URL?
    let lastMessage: Message
    
    //MARK: - Initialisation
    init (_ json: JSON){
       // print(json)
        self.id = json["conversation"]["peer"]["id"].intValue
        if  let urlString = json["conversation"]["chat_settings"]["photo"]["photo_50"].string {
            self.avatarUrl = URL(string: urlString)
        } else {
            self.avatarUrl = nil
        }
        self.lastMessage = Message(json["last_message"])
    }
}

struct Message: MessageType {
    var sender: SenderType {
        let id = authorId
        //if id > 0 {
        if let user = try! Realm().object(ofType: User.self, forPrimaryKey: id) {
            let name = "\(user.userName)"
            return Sender(id: String(id), displayName: name)
        }
//        } else if id < 0 {
//            let group = try! Realm().object(ofType: Group.self, forPrimaryKey: -id) {
//                let name = "\(group.name)"
//                return Sender(id: String(id), displayName: name)
//            }
       // }
        
        return Sender(id: String(id), displayName: "Unknown")
    }
    
    var messageId: String {
        return String(id)
    }
    
    var sentDate: Date {
        return date
    }
    
    var kind: MessageKind {
        return MessageKind.text(text)
    }
    
    let id: Int
    let date: Date
    let text: String
    let authorId: Int
    
    //MARK: - Initialisation
    init (_ json: JSON){
        self.id = json["id"].intValue
        self.text = json["text"].stringValue
        self.authorId = json["from_id"].intValue
        
        let dateDouble = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: dateDouble)
        
    }
}
