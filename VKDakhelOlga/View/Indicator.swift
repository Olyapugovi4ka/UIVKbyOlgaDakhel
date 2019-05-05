//
//  Indicator.swift
//  VKDakhelOlga
//
//  Created by MacBook on 29/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class Indicator: UIView, UIActivityIndicatorView! {
    
    let point1 = Point()
    let point2 = Point()
    let point3 = Point()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(Point)
    }
    }
}
class Point: UIView {
    
    let point = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = bounds.width/2

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         self.backgroundColor = .green
    }
    

    

}
