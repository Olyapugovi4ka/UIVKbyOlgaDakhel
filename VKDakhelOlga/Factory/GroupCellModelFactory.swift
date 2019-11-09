//
//  GroupCellModelFactory.swift
//  VKDakhelOlga
//
//  Created by Olga Melnik on 06.11.2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Kingfisher

final class GroupCellModelFactory {
    func constructViewModels(from groups: [AdaptGroup]) -> [GroupCellModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: AdaptGroup) -> GroupCellModel {
        let groupLabelText = group.name
        guard let imageString  = group.avatarName else { return GroupCellModel( groupNameText: groupLabelText, groupIconURL: nil)}
         let imageURL = URL(string: imageString)
        
        return GroupCellModel(groupNameText: groupLabelText, groupIconURL: imageURL)
    }
    
    
}
