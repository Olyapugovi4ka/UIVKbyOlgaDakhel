//
//  FriendsPhotoController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Kingfisher

//private let reuseIdentifier = "Cell"

class FriendsPhotoController: UICollectionViewController {
    
    
    public var friendName = ""
    public var userId : Int = 0
    
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
   
    //MARK: Array of photos
    public var  photosInFriendsPhotoController : [Photo] = []
        

 //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = friendName
       
        //MARK: - Request - photos of user
        networkingService.loadPhotos(userId) { response in
            switch response {
            case.success(let photos):
                self.photosInFriendsPhotoController = photos
                self.collectionView.reloadData()
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
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
