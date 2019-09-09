//
//  ChatCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/08/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import  Kingfisher
import RealmSwift

class ChatCell: UITableViewCell {
    
    static let reusedId = "ChatCell"
    @IBOutlet var avatarImageView: AvatarView!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    public func configer(with chat: Chat) {
        messageLabel.text = chat.lastMessage.text
        
        let id = chat.lastMessage.authorId
        
        if chat.avatarUrl != nil {
            avatarImageView.clippedImageView.kf.setImage(with: chat.avatarUrl)
        } else {
            do {
                if id > 0 {
                    let user = try Realm().object(ofType: User.self, forPrimaryKey: id)
                    contactNameLabel.text = user?.userName
                    if let imageString = user?.avatarName,
                        let imageURL = URL(string: imageString){
                        avatarImageView.clippedImageView.kf.setImage(with: imageURL)
                    }
                } else {
                    let group = try Realm().object(ofType: Group.self, forPrimaryKey: -id)
                    contactNameLabel.text = group?.name
                    if let imageString = group?.avatarName,
                        let imageURL = URL(string: imageString) {
                        avatarImageView.clippedImageView.kf.setImage(with: imageURL)
                    }
                }
            } catch {
                print ("No userAvatar and no groupAvatar")
            }
        }
        //TODO: get last message author's user name
//        do {
//            if id > 0 {
//                let user = try Realm().object(ofType: User.self, forPrimaryKey: id)
//                contactNameLabel.text = user?.userName
//
//            } else {
//                let group = try Realm().object(ofType: Group.self, forPrimaryKey: -id)
//                contactNameLabel.text = group?.name
//
//            }
//        } catch {
//            print ("No userName and no groupName")
//        }
    }

}
