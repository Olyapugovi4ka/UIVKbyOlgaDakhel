//
//  ShadowView.swift
//  VKDakhelOlga
//
//  Created by MacBook on 15/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class ShadowView: UIView{
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.75
    }
    override func layoutSubviews() {
        self.layer.cornerRadius = bounds.height/2
    }
}
