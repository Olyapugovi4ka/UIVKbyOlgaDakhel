//
//  BigPhotoController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 02/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class BigPhotoController: UIViewController {
    public var photoInBigPhotoController:[UIImage] = []
    public var startIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
        @IBOutlet var bigPhotoCollectionView: UICollectionView! {
            didSet {
                bigPhotoCollectionView.dataSource = self
                bigPhotoCollectionView.delegate = self
            }
        }
}
extension BigPhotoController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection secion: Int) -> Int {
        return photoInBigPhotoController.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigPhotoCell", for: indexPath) as! BigPhotoCell
        cell.photoInBigPhotoCell.image = photoInBigPhotoController[indexPath.item]
        return cell
    }
}
extension BigPhotoController: UICollectionViewDelegate {
    
}

extension BigPhotoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    return CGSize( width: collectionView.bounds.width,
    height: collectionView.bounds.height)
    }
}
