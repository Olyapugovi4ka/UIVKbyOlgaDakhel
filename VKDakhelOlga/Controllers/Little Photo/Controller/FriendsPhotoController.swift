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
    private var filteringOperations = OperationsManager(name: "Filtering Operations")
    
    //MARK: - For cashing of photos
    private var photos = [IndexPath:UIImage]()
    private let photoService = PhotoService()
        

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
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        filterImageOnScreen()
    }
    
    //MARK: Count of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosInFriendsPhotoController.count
    }
    
    //MARK: Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {fatalError()}
        
        cell.likeControl.addTarget(self, action: #selector(cellLikePressed(_:)), for: .valueChanged)
        
        if let filteredImage = photos[indexPath] {
            cell.photoInPhotoCell.image = filteredImage
        } else {
            let newPhoto = photosInFriendsPhotoController[indexPath.item]
            cell.configer(with: newPhoto, by: photoService)
        }
        return cell
    }
    
    //MARK: - For likeControl selector
    @objc func cellLikePressed(_ sender: LikeControl){
        print("The cell liked status set to: \(sender.isLiked).")
    }
    
    
    private func startFiltration(for image: UIImage, at indexPath: IndexPath) {
        guard filteringOperations.operationsInProgress[indexPath] == nil,
            photos[indexPath] == nil else { return }
        let sepiaOperation = SepiaFilterOperation(image)
        let vignetteOperation = VignetteFilterOperation()
        vignetteOperation.addDependency(sepiaOperation)
        vignetteOperation.completionBlock = {[weak self] in
            guard let self = self,
                !vignetteOperation.isCancelled else { return }
            self.photos[indexPath] = vignetteOperation.image
            DispatchQueue.main.async {
                self.filteringOperations.operationsInProgress[indexPath] = nil
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        filteringOperations.operationsInProgress[indexPath] = sepiaOperation
        filteringOperations.filteringQ.addOperations([sepiaOperation,vignetteOperation], waitUntilFinished: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBigPhoto"{
            if let indexPath = self.collectionView.indexPathsForSelectedItems?.first{
                let bigPhotoViewController = segue.destination as! BigPhotoController
                let photoId = photosInFriendsPhotoController[indexPath.item].photoId
                bigPhotoViewController.userId = self.userId
                bigPhotoViewController.photoId = photoId
                bigPhotoViewController.actualIndex = indexPath.section
                
            }
            
        }
    }
}

extension FriendsPhotoController {
    
    fileprivate func filterImageOnScreen() {
        let allCurrentoperationsIndexPaths = Set(filteringOperations.operationsInProgress.keys)
        let visibleIndexPath = Set(collectionView.indexPathsForVisibleItems)
        let toBeCancelled = allCurrentoperationsIndexPaths.subtracting(visibleIndexPath)
        for indexPath in toBeCancelled {
            filteringOperations.operationsInProgress[indexPath]?.cancel()
            filteringOperations.operationsInProgress[indexPath] = nil
        }
        for indexPath in visibleIndexPath {
            guard photos[indexPath] == nil else { return }
            let newPhoto = photosInFriendsPhotoController[indexPath.item]
            ImageCache.default.retrieveImage(forKey: newPhoto.name) { result in
                switch result {
                case .success(let value):
                    guard let image = value.image else { return }
                    self.startFiltration(for: image, at: indexPath)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        filteringOperations.filteringQ.isSuspended = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        filterImageOnScreen()
        filteringOperations.filteringQ.isSuspended = false
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            filterImageOnScreen()
            filteringOperations.filteringQ.isSuspended = false
        }
    }
}

//MARK: - size of cell
extension FriendsPhotoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = collectionView.bounds.width
        let size = CGSize(width: width, height: width)
        return size
    }
}

