//
//  GroupCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Kingfisher

class GroupCell: UITableViewCell {
    
    static let reuseId = "GroupCell"
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImage: AvatarView!
    
    public func configer (with group: AdaptGroup) {
        
        groupNameLabel.text = group.name
        
        if let imageString = group.avatarName,
            let imageUrl = URL(string: imageString){
            groupImage.clippedImageView.kf.setImage(with: imageUrl)
        }        
    }
}

