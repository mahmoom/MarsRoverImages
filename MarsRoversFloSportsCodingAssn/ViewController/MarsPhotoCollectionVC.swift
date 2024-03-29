//
//  ViewController.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class MarsPhotoCollectionVC: UICollectionViewController {
    
    //MARK: Variables
    var marsPhotoCollectionView: MarsPhotoCollectionView!
    
    var currentPage = 1
    var roverToSearch: Rovers = .curiosity
    var cameraToSearch: AllCameras = .NONE
    var date: String = Constants.defaultEarthDate
    var isFetchInProgress = false
    var roverPhotoObjects: [RoverImageData] = []

    //Outlet variables
    unowned var activityIndicator: UIActivityIndicatorView {return marsPhotoCollectionView.activityIndicator}
    unowned var emptyCollectionLabel: UILabel {return marsPhotoCollectionView.emptyCollectionLabel}
    
    //MARK: VC Life Cycle
    override func loadView() {
        super.loadView()
        marsPhotoCollectionView = MarsPhotoCollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
        collectionView = marsPhotoCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotosFromAPI()
        collectionView.register(MarsPhotoCollectionViewCell.self)
        collectionView?.prefetchDataSource = self
        collectionView?.dataSource = self
        self.title = "Mars Rover Images"
    }
    
    //MARK: Network function
    func getPhotosFromAPI(networkManager: NetworkManagerProtocol = NetworkManager()){
        
        guard !isFetchInProgress else {
          return
        }
        isFetchInProgress = true
        
        //Not great, but camera selection is optional and we don't have a nil camera enum val
        let camera: String?
        if cameraToSearch == .NONE{
            camera = nil
        } else{
            camera = cameraToSearch.rawValue
        }
        
        networkManager.getRoverPhotos(page: currentPage, earthDate: date, rover: roverToSearch.rawValue, camera: camera){ [weak self] (result) in
            guard let self = self else{return} //YAY SWFIT 4.2+!!!
            switch result{
            case .success(let photoResults):
                self.roverPhotoObjects.append(contentsOf: photoResults)
                self.currentPage += 1
                self.isFetchInProgress = false
                DispatchQueue.main.async{
                    self.activityIndicator.startAnimating()
                    if self.currentPage > 1{
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: photoResults)
                        self.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.onFetchCompleted(with: .none)
                    }
                    
                    if photoResults.isEmpty && self.roverPhotoObjects.isEmpty{
                        self.emptyCollectionLabel.isHidden = false
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async{
                    self.isFetchInProgress = false
                    print(error.reason)
                    let message = "We encountered a problem fetching the photos you requested. Please try again later"
                    self.onFetchFailed(with: message)
                }
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}


//MARK: helper functions
private extension MarsPhotoCollectionVC {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        //since we are showing 3 items per row, we want to start loading as we near the end of the scroll
        let count = roverPhotoObjects.count - 6
        if indexPath.row >= count{
            return true
        }
        
        //if user is scrolling too quickly and prefetchItems doesn't return desired index
        
        // calculated the distance from the bottom of the scrollview.
        let distanceFromBottom = collectionView.contentSize.height - (collectionView.bounds.size.height - collectionView.contentInset.bottom) - collectionView.contentOffset.y
        
        // if we are at the bottom of view and above if statement didn't execute
        // we check to see if fetch is in progress, but network call already does this
        // this is better for readability though
        if distanceFromBottom < 50 && !isFetchInProgress{
            return true
        }
        
        return false
    }
    
    private func calculateIndexPathsToReload(from newMarsPhotos: [RoverImageData]) -> [IndexPath]? {
        let startIndex = roverPhotoObjects.count - newMarsPhotos.count
        let endIndex = startIndex + newMarsPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func onFetchCompleted(with newIndexPathsToInsert: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToInsert else {
            activityIndicator.stopAnimating()
            return
        }
        collectionView.insertItems(at: newIndexPathsToReload)
        activityIndicator.stopAnimating()
    }
    
    func onFetchFailed(with message: String) {
        activityIndicator.stopAnimating()
        let title = "Sorry"
        Alert.showBasic(title: title, message: message, vc: self)
    }
}

//MARK: Data Source
extension MarsPhotoCollectionVC{
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MarsPhotoCollectionViewCell
        
        guard let imageUrl = roverPhotoObjects[indexPath.row].imageUrl else{return cell}
        cell.marsPhotoUrl = imageUrl
        
        //use KingFisher to handle image download and caching, or we could set in the cell. It IS technically a network call, but this could be handled either way at this time
//        let imageDownloader = ImageDownloader()
//        imageDownloader.downloadImageCacheAndAssignToImageView(imageUrl: imageUrl, imageView: cell.marsPhotoImageView)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roverPhotoObjects.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MarsPhotoCollectionViewCell
        cell.marsPhotoImageView.kf.cancelDownloadTask()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let marsRoverObject = roverPhotoObjects[indexPath.row]
        let detailController = MarsPhotoCollectionDetailVC(marsRoverImageObject: marsRoverObject)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}


//MARK: Prefetching Data Source
extension MarsPhotoCollectionVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            getPhotosFromAPI()
        }
    }
}

//MARK: Delegate Layout
extension MarsPhotoCollectionVC: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3, height: view.frame.width/3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
