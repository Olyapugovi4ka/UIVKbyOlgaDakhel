//
//  AddGroupController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift

class AddGroupController: UITableViewController {
    
    //MARK: - Service for requests
    private let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    // MARK: SearchBar
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    //MARK: - For storing datas
    private lazy var databaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recommendations.realm")
    public lazy var configuration = Realm.Configuration(fileURL: databaseURL, deleteRealmIfMigrationNeeded: true, objectTypes: [Group.self])
    
    // MARK: Array of Users(under models)
    private lazy var groups = try? RealmProvider.get(Group.self, configuration: configuration)
    
    //MARK: - Notification token
    private var notificationToken: NotificationToken?
    
    // MARK: SearchBar
    private var isSearching = false
    private var filteredGroups = [Group]()
  //  private var filteredGroups = [Group]()
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationToken?.invalidate()
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
        
        if isSearching {
            return filteredGroups.count
        } else {
            return groups?.count ?? 0
        }
        
    }
    
    //MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as? GroupCell,
        let group = isSearching ? filteredGroups[indexPath.row] : groups?[indexPath.row] else { fatalError("Cell cannot be dequeued") }
        cell.configer(with: group)
        return cell
    }
    
}
//MARK: SearchBar
extension AddGroupController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         isSearching = !searchText.isEmpty
        
        //MARK: - Request - search groups
        networkingService.loadSearchGroups(query: searchText)  { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let newGroups):
                self.filteredGroups = newGroups
                try! RealmProvider.save(items: newGroups, configuration: self.configuration)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}



