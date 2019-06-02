//
//  AddFriendController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class AddFriendController: UITableViewController {
    
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    // MARK: Array of Users(under models)
    public let users:[User] = [
//        User(userName: "Alex", avatarName: "Friends", photos: [Photo(name: "Friends", numberOfLikes: 0)]),
//        User(userName: "Mikhail", avatarName: "Friends", photos: [Photo(name: "Friends", numberOfLikes: 0)]),
//        User(userName: "Kate", avatarName: "Friends", photos: [Photo(name: "Friends", numberOfLikes: 0)]),
//        User(userName: "Marina", avatarName: "Marina", photos: [Photo(name: "Marina", numberOfLikes: 0), Photo(name: "Marina1", numberOfLikes: 0)]),
//        User(userName: "Leo", avatarName: "Friends", photos: [Photo(name: "Friends", numberOfLikes: 0)])
    ]
    
   //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Table view data source
    //MARK: Count of rows
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return users.count
        }
        
    //MARK: Cell
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.reuseId, for: indexPath) as? MyFriendsCell else {fatalError("Cell cannot be dequeued")}
           
            cell.userLabel.text = users[indexPath.row].userName
            let roundPhotoName = users[indexPath.row].avatarName
            cell.avatarView.avatarImage = UIImage(named:roundPhotoName)!
            
            return cell
        }
    

    
    

}
