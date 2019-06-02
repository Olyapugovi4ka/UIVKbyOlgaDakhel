//
//  AddGroupController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class AddGroupController: UITableViewController {
    
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    // MARK: SearchBar
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    // MARK: Array of Users(under models)
    public var groups:[Group] = [
//        Group(name: "Music", avatarName: "art"),
//        Group(name: "Interior and Decor", avatarName: "flame"),
//        Group(name: "Beauty", avatarName: "browser"),
//        Group(name: "Knitting world", avatarName: "art")
    ]
    
    // MARK: SearchBar
  //  private var filteredGroups = [Group]()
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:SearchBar
        //filteredGroups = groups
        
    }
    
    // MARK: SearchBar
//    private func filterGroups (with text: String) {
//        filteredGroups = groups.filter{ group in
//            return group.name.lowercased().contains(text.lowercased())
//        }
//
//        tableView.reloadData()
//    }
    
    
    //MARK: Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups.count
        
    }
    
    //MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as? GroupCell else {fatalError("Cell cannot be dequeued")}
        let group = groups[indexPath.row]
        cell.configer(with: group)
        return cell
    }
    
}
//MARK: SearchBar
extension AddGroupController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groups.removeAll()
            tableView.reloadData()
            return
        }
        //filterGroups(with: searchText)
        //MARK: - Request - search groups
       
        networkingService.loadSearchGroups(query: searchText)  { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let newGroups):
                self.groups.removeAll()
                self.groups = newGroups
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}



