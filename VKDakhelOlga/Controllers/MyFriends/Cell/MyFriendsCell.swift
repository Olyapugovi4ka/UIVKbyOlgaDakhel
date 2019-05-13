//
//  MyFriendsCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 08/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {
    
    static let reuseId = "MyFriendCell"
    
    //MARK: Outlets
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var userLabel: UILabel!
    
    //var user: User? {
    //    didSet{
     //       if let avatar = user?.avatarName {
      //          avatarView.avatarImage =  UIImage(named: avatar)!
       //     }
       // }
   // }
    

    

}
