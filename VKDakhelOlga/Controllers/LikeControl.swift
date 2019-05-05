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
        likesCount.text = "0"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        likesCount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heartImageView.heightAnchor.constraint(equalToConstant: bounds.height),
            heartImageView.widthAnchor.constraint(equalTo: heartImageView.heightAnchor),
            heartImageView.topAnchor.constraint(equalTo: self.topAnchor),
            heartImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            likesCount.trailingAnchor.constraint(equalTo: heartImageView.leadingAnchor),
            likesCount.widthAnchor.constraint(equalToConstant: 20),
            likesCount.bottomAnchor.constraint(equalTo: heartImageView.bottomAnchor)
            ])
    }
    
    // MARK: - Privates
    @objc func likeTapped(){
        isLiked.toggle()
        heartImageView.image = isLiked ? UIImage(named: "heart_filled") : UIImage(named: "heart_empty")
        likesCount.textColor = isLiked ? .red : .black
        if isLiked == true {
            UIView.transition(with: likesCount, duration: 1, options: .transitionCrossDissolve, animations: {
                self.likesCount.text = "1"
            })
            
        } else {
                UIView.transition(with: likesCount, duration: 1, options: .transitionCrossDissolve, animations: {
                    self.likesCount.text = "0"})

            
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
