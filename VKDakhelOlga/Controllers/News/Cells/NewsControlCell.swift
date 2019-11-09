//
//  NewsControlCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class NewsControlCell: UITableViewCell {
    
    static let reusedId = "NewsControlCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var repostLabel: UILabel!
    
    public func configer (with userLikes: Int) {
        if userLikes == 1 {
            likeButton.imageView?.image = UIImage(named: "heart_filled")
            likeLabel.textColor = .vkRed
        } else {
            likeButton.imageView?.image = UIImage(named: "heart_empty")
        }
    }
    
    @IBAction func toLike(_ sender: UIButton) {
        if likeButton.imageView?.image == UIImage(named: "heart_filled") {
            likeButton.setImage(UIImage(named: "heart_empty"), for: .normal)
            likeLabel.text = String(Int(likeLabel.text!)! - 1)
        } else {
            likeButton.setImage(UIImage(named: "heart_filled"), for: .normal)
            likeLabel.text = String(Int(likeLabel.text!)! + 1)
        }
        
    }
}
