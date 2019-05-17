//
//  GroupCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    static let reuseId = "GroupCell"
    
    //MARK: Outlets
    @IBOutlet weak var GroupNameLabel: UILabel!
    @IBOutlet weak var groupImage: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }


}

