//
//  AllChatsTableViewController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/08/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift

class AllChatsTableViewController: UITableViewController {
    
    private var chats = [Chat]()
    
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    //MARK: - Observer
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkingService.getLongPollServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkingService.getConversations { [weak self] result in
            switch result {
            case .success(let chats):
                self?.chats = chats
                self?.tableView.reloadData()
            case.failure(let error):
                self?.show(error)
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reusedId, for: indexPath) as! ChatCell
        
        let chat = chats[indexPath.row]

        cell.configer(with: chat)

        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let chatVC = ChatViewController()
            chatVC.chatId = chats[indexPath.row].id
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}
