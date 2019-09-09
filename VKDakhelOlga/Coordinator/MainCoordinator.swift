//
//  MainCoordinator.swift
//  VKDakhelOlga
//
//  Created by MacBook on 26/08/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: CustomNavigationController
    
    init(navigationController: CustomNavigationController) {
        self.navigationController = navigationController
    }
    
    func start(){
//        let viewController = LoginVKController()
//        viewController.coordinator = self
    }
    
    func showFriends(){
//        let viewController = MyFriendsController.instantiate()
//        viewController.coordinator = self
    }
    
    func showGroups(){
//        let viewController = MyGroupsController.instantiate()
//        viewController.coordinator = self
    }
    
    func showNews(){
//        let viewController = NewsController.instantiate()
//        viewController.coordinator = self
    }
}
