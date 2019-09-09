//
//  PhotoCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    static let reuseId = "PhotoCell"
    
    @IBOutlet var photoInPhotoCell: UIImageView!
    @IBOutlet var likeControl: LikeControl!
  
    public func configer (with photo: Photo, by photoService: PhotoService) {
        let countOfLikes = String(photo.numberOfLikes)
        likeControl.likesCount.text = countOfLikes
        
        let imageString = photo.name
        //let imageUrl = URL(string: imageString)
        //photoInPhotoCell.kf.setImage(with: imageUrl)
        
        //MARK: - Using my own cash service
        photoService.photo(with: imageString).done { [weak self] image in
            guard let self = self else { return }
            self.photoInPhotoCell.image = image
            }.catch { error in
                print(error)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(photoTapped))
        self.photoInPhotoCell.addGestureRecognizer(tapGR)
        self.photoInPhotoCell.isUserInteractionEnabled = true

    }
    
    //MARK: - For tapGR selector
    @objc func photoTapped() {
        
       let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.7
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
 
        self.photoInPhotoCell.layer.add(animation, forKey: nil)
    }
}

