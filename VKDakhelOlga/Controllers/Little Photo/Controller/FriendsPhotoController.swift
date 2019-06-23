//
//  FriendsPhotoController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsPhotoController: UICollectionViewController {
    
    
    public var friendName = ""
    public var userId : Int = 0
    
    //MARK: - Service for requests
    private let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
   
    //MARK: Array of photos
    public lazy var  photosInFriendsPhotoController : Results<Photo> = try! RealmProvider.get(Photo.self).filter("userId == %@", userId)
    
    //MARK: - Observer
    private var notificationToken: NotificationToken?
        

 //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = friendName
       
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
        notificationToken = photosInFriendsPhotoController.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                print("notification token was initialized")
                self.collectionView.reloadData()
            case .update:
                self.collectionView.reloadData()
            case .error(let error):
                self.show(error)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationToken?.invalidate()
    }
    //MARK: Count of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    //MARK: Count of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosInFriendsPhotoController.count
    }

    //MARK: Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {fatalError()}
        cell.likeControl.addTarget(self, action: #selector(cellLikePressed(_:)), for: .valueChanged)
        let newPhoto = photosInFriendsPhotoController[indexPath.item]
        cell.configer(with: newPhoto)
        return cell
        }
        
    
        //MARK: Private
    @objc func cellLikePressed(_ sender: LikeControl){
        print("The cell liked status set to: \(sender.isLiked).")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBigPhoto",
            let bigPhotoViewController = segue.destination as? BigPhotoController,
            let index = collectionView.indexPathsForSelectedItems?.first?.item {
            bigPhotoViewController.currentIndex = index
            bigPhotoViewController.photosInBigPhotoController = photosInFriendsPhotoController
            }
        }
}
