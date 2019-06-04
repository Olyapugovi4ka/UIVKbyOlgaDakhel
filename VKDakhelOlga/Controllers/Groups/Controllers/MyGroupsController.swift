//
//  MyGroupsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
 
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    // MARK: SearchBar
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
     // MARK: Array of Users(under models)
    private var groups:[Group] = []
    
    
    
    // MARK: SearchBar
    private var filteredGroups = [Group]()
    
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
                self.filteredGroups = groups
                self.tableView.reloadData()
            case .failure(let error):
                self.show(error)
            }
        }
        
        
    }
    
    // MARK: SearchBar
    private func filterGroups (with text: String) {
        filteredGroups = groups.filter{ group in
            return group.name.lowercased().contains(text.lowercased())
        }
       
        tableView.reloadData()
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
            let group = filteredGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let index = groups.firstIndex(where: {$0.name == group.name}){
            groups.remove(at:index)
            }
        }
        
    }
    // MARK: Navigation
    
    //MARK: Adding new group
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if let addGroupController = segue.source as? AddGroupController,
            let indexPath = addGroupController.tableView.indexPathForSelectedRow {
            let newGroup = addGroupController.groups[indexPath.row]
            guard !groups.contains(where: { (Group) -> Bool in
                return Group.name == newGroup.name
            }) else {return}
            self.groups.append(newGroup)
            filteredGroups = groups
            tableView.reloadData()
        }
        
    }
    
}
//MARK: SearchBar
extension MyGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroups = groups
            
            //MARK: - Request - search groups
           
             //   networkingService.loadSearchGroups(query: searchText)
            
            tableView.reloadData()
            return
        }
        filterGroups(with: searchText)
    }
    
}
