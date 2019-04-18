//
//  ShadowView.swift
//  VKDakhelOlga
//
//  Created by MacBook on 15/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

@IBDesignable class ShadowView: UIView{
    @IBInspectable var shadowColor: UIColor = .green
    @IBInspectable var shadowRadius: CGFloat = 7
    @IBInspectable var shadowOpacity: Float = 0.75
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView(){
        backgroundColor = .white
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        self.layer.cornerRadius = bounds.height/2
    }
}

class ClippedView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = bounds.height/2
    }
}

class AvatarView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .green
    @IBInspectable var shadowRadius: CGFloat = 7
    @IBInspectable var shadowOpacity: Float = 0.75
    @IBInspectable var avatarImage: UIImage = UIImage(named: "Friends")! {
        didSet {
            clippedImageView.image = avatarImage
        }
    }
    let shadowView = ShadowView()
    let clippedImageView = ClippedView(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.masksToBounds = false
        addSubview(shadowView)
        
        clippedImageView.image = avatarImage
        addSubview(clippedImageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.frame = bounds
        clippedImageView.frame = bounds
        
    }
    
}
