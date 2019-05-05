//
//  FriendsPhotoController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class FriendsPhotoController: UICollectionViewController {
    
    public var friendName = ""
    public var photoInFriendsPhotoController:[UIImage] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        title = friendName
        
       

    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoInFriendsPhotoController.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {fatalError()}
        cell.likeControl.addTarget(self, action: #selector(cellLikePressed(_:)), for: .valueChanged)
        cell.photoInPhotoCell.image = photoInFriendsPhotoController[indexPath.item]
        // Configure the cell
    
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
                bigPhotoViewController.startIndex = index
                bigPhotoViewController.photoInBigPhotoController = photoInFriendsPhotoController
            }
        }
}
