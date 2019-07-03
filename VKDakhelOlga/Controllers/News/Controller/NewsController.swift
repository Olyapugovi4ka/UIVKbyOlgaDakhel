//
//  TableViewController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift

class NewsController: UITableViewController {
   
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    //MARK: - Observer
    var notificationToken: NotificationToken?
    
    let news: Results<News> = try! RealmProvider.get(News.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Server request
        networkingService.loadNews {[weak self] responce in
            //MARK: - creating a queue
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async {
                
                guard let self = self else { return }
                switch responce {
                case .success(let news):
                    try! RealmProvider.save(items: news)
                case .failure(let error):
                    self.show(error)
                }
            }
        }
        
        notificationToken = news.observe { change in
            switch change {
            case .initial:
                self.tableView.reloadData()
            case .update:
                self.tableView.reloadData()
            case .error(let error):
                self.show(error)
            }
        }
    }

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
            let sourceId = news[indexPath.section].sourceId
           // if userId > 0 {
            
//                let userValues:Results<User> = {
//                    return
//                }()
           // }
          //  let user = userValues[indexPath.row]
           // cell.configer(with: user)
            
            return cell
        //MARK: Second row
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
                let text = news[indexPath.section].newsText
            
            //MARK: - returning to main queue
            DispatchQueue.main.async {
                cell.textField.text = text
            }
            
            return cell
            //MARK: Third row
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell
//            if let image = news[indexPath.section].newsPhoto?.name {
//                    cell.newsImage.image = UIImage(named: image)!
//            }
//            let newPhoto = photosInFriendsPhotoController[indexPath.item]
//            cell.configer(with: newPhoto)
//            return cell
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
