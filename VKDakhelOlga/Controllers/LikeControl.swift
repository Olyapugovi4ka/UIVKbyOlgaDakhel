//
//  LikeControl.swift
//  VKDakhelOlga
//
//  Created by MacBook on 16/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    
    public var isLiked: Bool = false
    let heartImageView = UIImageView()
    var likesCount = UILabel()
    var countValue:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        setupView()
    }
    
    private func setupView() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        heartImageView.isUserInteractionEnabled = true
        heartImageView.addGestureRecognizer(tapGR)
        addSubview(heartImageView)
        heartImageView.image = UIImage(named: "heart_empty")
        addSubview(likesCount)
        likesCount.text = "\(String(countValue))"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heartImageView.frame = bounds
    }
    
    // MARK: - Privates
    @objc func likeTapped(){
        isLiked.toggle()
        heartImageView.image = isLiked ? UIImage(named: "heart_filled") : UIImage(named: "heart_empty")
        if isLiked == true {
            countValue += 1
            likesCount.textColor = .red
        } else {
            countValue -= 1
        }
            
            
        sendActions(for: .valueChanged)
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
