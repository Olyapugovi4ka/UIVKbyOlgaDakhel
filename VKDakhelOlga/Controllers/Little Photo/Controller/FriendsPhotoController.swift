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
    
   
    //MARK: Array of photos
    public var  photosInFriendsPhotoController : [Photo]? = []
        

 //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = friendName
    }
    //MARK: Count of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    //MARK: Count of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosInFriendsPhotoController!.count
    }

    //MARK: Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {fatalError()}
        cell.likeControl.addTarget(self, action: #selector(cellLikePressed(_:)), for: .valueChanged)
        
        let newPhoto = photosInFriendsPhotoController![indexPath.item].name
            cell.photoInPhotoCell.image = UIImage(named: newPhoto)
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
                bigPhotoViewController.photosInBigPhotoController = photosInFriendsPhotoController!
            }
        }
}
