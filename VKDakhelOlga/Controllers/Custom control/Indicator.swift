//
//  Indicator.swift
//  VKDakhelOlga
//
//  Created by MacBook on 29/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class Indicator:UIView {
   
    var point1: CAShapeLayer!
    var point2: CAShapeLayer!
    var point3: CAShapeLayer!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createPoints()
        indicate()
       
         }
    
   private func createPoints () {
        point1 = CAShapeLayer()
        let rect1 = CGRect(x: 0, y: self.frame.height/2 - 5, width: 10, height: 10)
        point1.path = UIBezierPath(ovalIn: rect1).cgPath
    point1.fillColor = UIColor.vkGreen.cgColor
        self.layer.addSublayer(point1)
        
        point2 = CAShapeLayer()
        let rect2 = CGRect(x: self.frame.width/2 - 5, y: self.frame.height/2 - 5, width: 10, height: 10)
        point2.path = UIBezierPath(ovalIn: rect2).cgPath
        point2.fillColor = UIColor.vkGreen.cgColor
        self.layer.addSublayer(point2)
        
        point1 = CAShapeLayer()
        let rect3 = CGRect(x: self.frame.width - 10, y: self.frame.height/2 - 5, width: 10, height: 10)
        point3.path = UIBezierPath(ovalIn: rect3).cgPath
        point3.fillColor = UIColor.vkGreen.cgColor
        self.layer.addSublayer(point3)
}
    public func indicate() {
      let animation1 = CABasicAnimation(keyPath: "alpha")
        animation1.fromValue = 0.5
        animation1.toValue = 1
        animation1.beginTime = CACurrentMediaTime()
        animation1.duration = 0.5
        point1.add(animation1, forKey: "firstDotBlinking")
        
        let animation2 = CABasicAnimation(keyPath: "alpha")
        animation2.fromValue = 0.5
        animation2.toValue = 1
        animation2.beginTime = CACurrentMediaTime() + 0.33
        animation2.duration = 0.5
        point2.add(animation2, forKey: nil)
        
        let animation3 = CABasicAnimation(keyPath: "alpha")
        animation3.fromValue = 0.5
        animation3.toValue = 1
        animation3.beginTime = CACurrentMediaTime() + 0.66
        animation3.duration = 0.5
        point3.add(animation3, forKey: nil)

    }

    public func start() {
        indicate()
    }
    
    public func stop() {
        //        self.layer.removeAnimation(forKey: "firstDotBlinking")
        layer.removeAllAnimations()
    }
    
    

}
