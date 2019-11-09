//
//  BigPhotoController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 02/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class BigPhotoController: UIViewController {
    
    //MARK: - Service for requests
    
    
    @IBOutlet var activeImageView: UIImageView!
    var actualIndex: Int = 0
    var actualPhotoName:String = ""
   // var photoNameArray[Int] = String
    public var userId: Int = 0
    public var photoId: Int = 0
    public lazy var photosInBigPhotoController :Results<Photo> = try! RealmProvider.get(Photo.self).filter("userId == %@", userId)
    
    private let networkingService = NetworkingService(token: Account.shared.token ?? "")
    private var notificationToken: NotificationToken?
   
    //MARK: - animation
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
        
      
        
        //MARK: - Request - photos of user
        networkingService.loadPhotos(userId) { response in
            switch response {
            case.success(let photos):
                try? RealmProvider.save(items: photos)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //MARK: - Observer
        notificationToken = photosInBigPhotoController.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                print("notification token was initialized")
            case .update:
                
                print("photo was update")
            
            case .error(let error):
                self.show(error)
            }
        }
        
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        leftSwipeGR.direction = .left
        activeImageView.addGestureRecognizer(leftSwipeGR)
        
        let rightSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGR.direction = .right
        activeImageView.addGestureRecognizer(rightSwipeGR)
       
        //MARK: - converting photo
        guard let photo = photosInBigPhotoController.filter("photoId == %@", photoId).first else { return }
        
        actualPhotoName = photo.name
        let imageUrl = URL(string: actualPhotoName)
        
       
        activeImageView.kf.setImage(with: imageUrl)
      
        
    
    }
    
    @objc func swipedLeft() {
        
        guard actualIndex < photosInBigPhotoController.count - 1 else { return }
        print(actualIndex)
        
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
            self.actualIndex += 1
            let photoName = self.photosInBigPhotoController[self.actualIndex].name
            let photoUrl = URL(string:photoName)
            self.activeImageView.kf.setImage(with: photoUrl)
          
            self.activeImageView.transform = .identity
        }
    }
    
    @objc func swipedRight() {
        guard actualIndex >= 1 else { return }
        
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
            self.actualIndex -= 1
            let photoName = self.photosInBigPhotoController[self.actualIndex].name
            let photoUrl = URL(string:photoName)
            self.activeImageView.kf.setImage(with: photoUrl)
            
            self.activeImageView.transform = .identity
        }
    }
    
    
    @IBAction func swipedUp(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationToken?.invalidate()
    }
}
