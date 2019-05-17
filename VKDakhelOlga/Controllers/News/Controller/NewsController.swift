//
//  TableViewController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    
    let news:[News] = [News(user: User(userName: "John", avatarName: "flame", photos: nil), newsText: "Hellow everybody", newsPhoto: Photo(name: "News", numberOfLikes: 0))]
    
   

    // MARK: - Table view data source
    
    //MARK: Count of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return news.count
    }

    //MARK: Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 4
    }
    
    //MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        //MARK: First row
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as! NewsHeaderCell
            cell.userLabel.text = news[indexPath.row].user.userName
            if let image = news[indexPath.row].user.avatarName{
                cell.avatarView.avatarImage = UIImage(named: image)!
            }
            return cell
        //MARK: Second row
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
                let text = news[indexPath.section].newsText
                cell.textField.text = text
            
            return cell
            //MARK: Third row
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell
            if let image = news[indexPath.section].newsPhoto?.name {
                    cell.newsImage.image = UIImage(named: image)!
            }
            return cell
            //MARK: Forth row
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsControlCell", for: indexPath) as! NewsControlCell
            return cell
            //MARK: Other cases
        default:
            return UITableViewCell()
        }
    }
    
}
