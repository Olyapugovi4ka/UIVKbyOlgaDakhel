//
//  VKAdapter.swift
//  VKDakhelOlga
//
//  Created by Olga Melnik on 04.11.2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import Alamofire
import  SwiftyJSON
import RealmSwift

class VKAdapter {
    //private let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    //MARK: - Observer
      private var notificationToken: NotificationToken?
    //MARK: - proxy
    private let proxy = NetworkingServiceProxy()
    
    func getGroups(completion: @escaping ([AdaptGroup]) -> Void){
        let groups: Results<Group> = try! RealmProvider.get(Group.self)
        //var filteredGroups: Results<Group> = try! RealmProvider.get(Group.self)
        //filteredGroups = groups
        proxy.loadGroups { responce in
            switch responce {
            case .success(let groups):
                try! RealmProvider.save(items: groups)
            case .failure(let error):
                fatalError("\(error)")
            }
        }
        var adaptGroups:[AdaptGroup] = []
        for group in groups {
            adaptGroups.append(self.adaptGroup(from: group))
        }
        completion(adaptGroups)
        
                notificationToken = groups.observe { change in
                    switch change {
                    case .initial:
                        break
                    case .update(let groups, _, _, _):
                        var adaptGroups:[AdaptGroup] = []
                        for group in groups {
                            adaptGroups.append(self.adaptGroup(from: group))
                            
                        }
                        completion(adaptGroups)
                        //self.tableView.reloadData()
                    case .error(let error):
                       fatalError("\(error)")
                    }
                }
        
    }
    
    func delete(_ item: AdaptGroup){
        let groups:Results<Group> = try! RealmProvider.get(Group.self).filter("id CONTAINS[cd] %@",item.id)
        guard let group = groups.first else { return }
        try! RealmProvider.delete(items: group)
    }
    
    func loadSearchGroups(text: String, completion: ([AdaptGroup]) -> Void){
        let searchingGroups: Results<Group> = try! RealmProvider.get(Group.self).filter("name CONTAINS[cd] %@",text)
        var adaptGroups:[AdaptGroup] = []
        for group in searchingGroups {
            adaptGroups.append(self.adaptGroup(from: group))
        }
        completion(adaptGroups)
    }
    
    private func adaptGroup(from group: Group) -> AdaptGroup {
        return AdaptGroup(id: group.id,
                          name: group.name,
                          avatarName: group.avatarName)
    }
    
//    private func group(from adaptGroup : AdaptGroup) -> Group {
//        return Group(
//    }
}
