//
//  BigPhotoController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 02/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift

class BigPhotoController: UIViewController {
    
    @IBOutlet var activeImageView: UIImageView!
    
    public var photoId: Int = 0
    
    public lazy var photosInBigPhotoController : Results<Photo> = try! RealmProvider.get(Photo.self).filter("photoId == %@", photoId)
    
    
    private lazy var scaleTrasform: CGAffineTransform = {
        return CGAffineTransform(scaleX: 0.8, y: 0.8)
    }()
    private lazy var goLeftTrasform: CGAffineTransform = {
        return CGAffineTransform(translationX: -view.bounds.width, y: 0)
    }()
    private lazy var goRightTrasform: CGAffineTransform = {
        return CGAffineTransform(translationX: view.bounds.width, y: 0)
    }()
    
    private let animationDuration = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        leftSwipeGR.direction = .left
        activeImageView.addGestureRecognizer(leftSwipeGR)
        
        let rightSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGR.direction = .right
        activeImageView.addGestureRecognizer(rightSwipeGR)
        
        let image = UIImage(named: photosInBigPhotoController[photoId].name)
        activeImageView.image = image
        activeImageView.backgroundColor = UIColor.lightGray
    }
    //        @IBOutlet var bigPhotoCollectionView: UICollectionView! {
    //            didSet {
    //                bigPhotoCollectionView.dataSource = self
    //                bigPhotoCollectionView.delegate = self
    //            }
    //        }
    
    @objc func swipedLeft() {
        guard photoId < photosInBigPhotoController.count - 1 else { return }
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModeCubicPaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.3, animations: {
                                self.activeImageView.transform = self.scaleTrasform
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3,
                               relativeDuration: 0.7, animations: {
                                self.activeImageView.transform = self.scaleTrasform.concatenating(self.goLeftTrasform)
            })
        }) { _ in
            self.photoId += 1
            let image = UIImage(named: self.photosInBigPhotoController[self.photoId].name)
            self.activeImageView.image = image
            self.activeImageView.transform = .identity
        }
    }
    
    @objc func swipedRight() {
        guard photoId >= 1 else { return }
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModeCubicPaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.3, animations: {
                                self.activeImageView.transform = self.scaleTrasform
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3,
                               relativeDuration: 0.7, animations: {
                                self.activeImageView.transform = self.scaleTrasform.concatenating(self.goRightTrasform)
            })
        }) { _ in
            self.photoId -= 1
            let image = UIImage(named: self.photosInBigPhotoController[self.photoId].name)
            self.activeImageView.image = image
            self.activeImageView.transform = .identity
        }
    }
    
    
    @IBAction func swipedUp(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
