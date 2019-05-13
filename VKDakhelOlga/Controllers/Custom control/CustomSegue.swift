//
//  CustomSegue.swift
//  VKDakhelOlga
//
//  Created by MacBook on 10/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    
    let animationDuration: TimeInterval = 1
    
    override func perform() {
        
        guard let container = source.view else { return }
        
        let pi = CGFloat(Double.pi)
        
        let offScreenRotateIn = CGAffineTransform(rotationAngle: -pi/2)
       // let offScreenRotateOut = CGAffineTransform(rotationAngle: pi/2)
        
        destination.view.transform = offScreenRotateIn
        
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        destination.view.layer.position = CGPoint(x: 0, y: 0)
        
        container.addSubview(destination.view)
        
        let duration = self.animationDuration
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.49,
                       initialSpringVelocity: 0.81,
                       options: [],
                       animations: {
                        self.destination.view.transform = .identity},
                       completion: { finished in
                        self.source.present(self.destination, animated: false)
        })
        
    }
}
