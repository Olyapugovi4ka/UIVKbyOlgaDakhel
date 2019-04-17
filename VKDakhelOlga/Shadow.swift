//
//  Shadow.swift
//  VKDakhelOlga
//
//  Created by MacBook on 14/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//


    import UIKit
    
    @IBDesignable class ShadowViewController: UIView {
        
        @IBInspectable public var filled = true {
            didSet {
                setNeedsDisplay()
            }
        }
        
        @IBInspectable var radius: CGFloat = 25
        
    }
    
    extension UIView {
        
        @IBInspectable var shadowColor: CGColor {
            set { layer.shadowColor = newValue}
            get { return layer.shadowColor ?? UIColor.blue.cgColor}
        }
        @IBInspectable var shadowOpacity: Float {
            set { layer.shadowOpacity = newValue}
            get { return layer.shadowOpacity }
        }
        @IBInspectable var shadowRadius: CGFloat {
            set { layer.shadowRadius = newValue}
            get { return layer.shadowRadius}
        }
        @IBInspectable var shadowOffset: CGSize {
            set { layer.shadowOffset = newValue}
            get { return layer.shadowOffset}
        }
    }    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


