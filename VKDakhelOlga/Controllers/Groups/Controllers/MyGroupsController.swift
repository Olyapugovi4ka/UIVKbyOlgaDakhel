//
//  MyGroupsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController {
    
    //MARK: - pattern fabrica
    private let groupCellModelFactory = GroupCellModelFactory()
    private var groupCellModels:[GroupCellModel] = []
    
 
    //MARK: - Service for requests
    private var vkAdapter = VKAdapter()
   // let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    //MARK: - Observer
    private var notificationToken: NotificationToken?
    
    // MARK: SearchBar
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
     // MARK: Array of Groups(under models)
    private var groups:[AdaptGroup] = []
    
    // MARK: Array of filterd groups for SearchBar
    private var filteredGroups:[AdaptGroup] = []
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - request with adapter
        vkAdapter.getGroups{ [weak self] groups in
            self?.groups = groups
            
            self?.tableView.reloadData()
        }
        //MARK:SearchBar
        filteredGroups = groups
        groupCellModels = groupCellModelFactory.constructViewModels(from: filteredGroups)
    }
    
    //MARK: - Creating notification token
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: Invalidation of notification token
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationToken?.invalidate()
    }
    
    //MARK: - Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
      return groupCellModels.count
    
    }
    
    //MARK: - Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as? GroupCell else {fatalError("Cell cannot be dequeued")}
        cell.configer(with: groupCellModels[indexPath.row])
        return cell
    }
    
    //MARK: - For deleting
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let group = filteredGroups[indexPath.row]
            self.vkAdapter.delete(group)
           // try! RealmProvider.delete(items: group)
        }
    }
}

//MARK: - SearchBar
extension MyGroupsController: UISearchBarDelegate {
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            if searchText.isEmpty {
                filteredGroups = groups
                tableView.reloadData()
                return
            }
            self.vkAdapter.loadSearchGroups(text: searchText) { (groups) in
                filteredGroups = groups
            }
            //        let searchingGroups: Results<Group> = try! RealmProvider.get(Group.self).filter("name CONTAINS[cd] %@",searchText)
            // filteredGroups = searchingGroups
            tableView.reloadData()
        }
        
    }

