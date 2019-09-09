//
//  Coordinator.swift
//  VKDakhelOlga
//
//  Created by MacBook on 26/08/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators:[Coordinator] { get set }
    var navigationController: CustomNavigationController { get set }
    
    func start()
}
