//
//  AddGroupController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class AddGroupController: UITableViewController {

    // MARK: Array of Users(under models)
    public let groups:[Group] = [
        Group(name: "Music", avatarName: "art"),
        Group(name: "Interior and Decor", avatarName: "flame"),
        Group(name: "Beauty", avatarName: "browser"),
        Group(name: "Knitting world", avatarName: "art")
    ]
    
     //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return groups.count
    }
    
    //MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as? GroupCell else {fatalError("Cell cannot be dequeued")}
            cell.GroupNameLabel.text = groups[indexPath.row].name
                if let roundPhotoName = groups[indexPath.row].avatarName {
                    cell.groupImage.avatarImage = UIImage(named:roundPhotoName)!
                }
            return cell
        }
}
     
    
    

