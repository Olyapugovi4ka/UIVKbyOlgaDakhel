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
 
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    //MARK: - Observer
    var notificationToken: NotificationToken?
    
    // MARK: SearchBar
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
     // MARK: Array of Groups(under models)
    private var groups: Results<Group> = try! RealmProvider.get(Group.self)
    
    
    // MARK: Arrat of filterd groups for SearchBar
    private var filteredGroups: Results<Group> = try! RealmProvider.get(Group.self)
    
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:SearchBar
        filteredGroups = groups
        
        //MARK: - Server request
        networkingService.loadGroups {[weak self] responce in
            guard let self = self else { return }
            switch responce {
            case .success(let groups):
                try! RealmProvider.save(items: groups)
            case .failure(let error):
                self.show(error)
            }
        }
        
        notificationToken = filteredGroups.observe { change in
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
    
    // MARK: Invalidation of notification token
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationToken?.invalidate()
    }
    
    //MARK: Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
      return filteredGroups.count
    
    }
    
    //MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as? GroupCell else {fatalError("Cell cannot be dequeued")}
        let group = filteredGroups[indexPath.row]
       cell.configer(with: group)
        return cell
    }
    
    //MARK: For deleting
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let group = filteredGroups[indexPath.row]
            try! RealmProvider.delete(items: group)
        }
    }
    
    
}

//MARK: SearchBar
extension MyGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchText.isEmpty {
            filteredGroups = groups
            tableView.reloadData()
            return
        }
        let searchingGroups: Results<Group> = try! RealmProvider.get(Group.self).filter("name CONTAINS[c]'\(searchText)")
        filteredGroups = searchingGroups
        tableView.reloadData()
    }
    
}
// MARK: Navigation

//MARK: Adding new group
//    @IBAction func addGroup(segue: UIStoryboardSegue) {
//
//        if let addGroupController = segue.source as? AddGroupController,
//            let indexPath = addGroupController.tableView.indexPathForSelectedRow {
//            let newGroup = addGroupController.groups[indexPath.row]
//            guard !groups.contains(where: { (Group) -> Bool in
//                return Group.name == newGroup.name
//            }) else {return}
//            self.groups.append(newGroup)
//            filteredGroups = groups
//            tableView.reloadData()
//        }
//
// }

//}
