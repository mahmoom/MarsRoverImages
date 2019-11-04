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
    
    var marsPhotoCollectionView: MarsPhotoCollectionView!

    unowned var activityIndicator: UIActivityIndicatorView {return marsPhotoCollectionView.activityIndicator}
    unowned var emptyCollectionLabel: UILabel {return marsPhotoCollectionView.emptyCollectionLabel}
    
//    let activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView()
//        indicator.hidesWhenStopped = true
//        if #available(iOS 13.0, *) {
//            indicator.style = .large
//        } else {
//            // Fallback on earlier versions
//            indicator.style = .whiteLarge
//        }
//        indicator.color = .gray
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        indicator.startAnimating()
//        return indicator
//    }()
    
    enum State {
        case noData
        case loaded
    }
    var state: State = .noData {
        didSet {
            switch state {
            case .noData:
//                noDataView.isHidden = false
                collectionView.isHidden = true
            case .loaded:
//                noDataView.isHidden = false
                collectionView.isHidden = true
            }
        }
    }
    
    var currentPage = 1
    var roverToSearch: Rovers = .curiosity
    var cameraToSearch: AllCameras = .NONE
    var date: String = Constants.defaultEarthDate
    private var isFetchInProgress = false
    
    var roverPhotoObjects: [RoverImageData] = []
    
    override func loadView() {
        super.loadView()
        marsPhotoCollectionView = MarsPhotoCollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
        collectionView = marsPhotoCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        collectionView.backgroundColor = .black
        collectionView.register(MarsPhotoCollectionViewCell.self)
        getPhotosFromAPI()
        setupNavBar()
        collectionView?.prefetchDataSource = self
    }
    
    func setupNavBar(){
        self.title = "Mars Rover Images"
    }
    
    //perform network call
    private func getPhotosFromAPI(networkManager: NetworkManagerProtocol = NetworkManager()){
        
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        
        let camera: String?
        if cameraToSearch == .NONE{
            camera = nil
        } else{
            camera = cameraToSearch.rawValue
        }
        
        switch roverToSearch {
        case .curiosity:
            networkManager.getCuriosityPhotos(page: currentPage, camera: camera, earthDate: date) { [weak self] (result) in
                self?.handleNetworkRequestResult(result)
            }
        case .opportunity:
            networkManager.getOpportunityPhotos(page: currentPage, camera: camera, earthDate: date) { [weak self] (result) in
                self?.handleNetworkRequestResult(result)
            }
        case .spirit:
            networkManager.getSpiritPhotos(page: currentPage, camera: camera, earthDate: date) { [weak self] (result) in
                self?.handleNetworkRequestResult(result)
            }
        }
        //This is how the network call was when I was providing default rover and no camera
//        networkManager.getRoverPhotos(page: currentPage) { [weak self] (result) in
//            switch result{
//            case .success(let photoResults):
//                DispatchQueue.main.async{
//                    self?.activityIndicator.startAnimating()
//                    self?.currentPage += 1
//                    self?.isFetchInProgress = false
//                    self?.roverPhotoObjects.append(contentsOf: photoResults)
//
//                    if self?.currentPage ?? 0 > 1{
//                        let indexPathsToReload = self?.calculateIndexPathsToReload(from: photoResults)
//                        self?.onFetchCompleted(with: indexPathsToReload)
//                    } else {
//                        self?.onFetchCompleted(with: .none)
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async{
//                    self?.isFetchInProgress = false
//                    print(error.reason)
//                    let message = "We encountered a problem fetching the photos you requested. Please try again later"
//                    self?.onFetchFailed(with: message)
//                }
//            }
//        }
    }
    
    func handleNetworkRequestResult(_ result: Result<[RoverImageData], DataResponseError>){
        switch result{
        case .success(let photoResults):
            DispatchQueue.main.async{
                self.activityIndicator.startAnimating()
                self.currentPage += 1
                self.isFetchInProgress = false
                self.roverPhotoObjects.append(contentsOf: photoResults)

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
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}


//MARK: helper functions
private extension MarsPhotoCollectionVC {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    //since we are showing 3 items per row, we want to start loading as we near the end of the scroll
    let count = roverPhotoObjects.count - 6
    return indexPath.row >= count
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
    let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
    
    private func calculateIndexPathsToReload(from newMarsPhotos: [RoverImageData]) -> [IndexPath]? {
        let startIndex = roverPhotoObjects.count - newMarsPhotos.count
        let endIndex = startIndex + newMarsPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            collectionView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
        activityIndicator.stopAnimating()
    }
    
    func onFetchFailed(with message: String) {
        activityIndicator.stopAnimating()
        let title = "Sorry"
        Alert.showBasic(title: title, message: message, vc: self)
    }
    
//    func startDownload(for photoRecord: RoverImageData, at indexPath: IndexPath) {
//      //1
//      guard loadingOperations[indexPath] == nil else {
//        return
//      }
//
//      //2
//      let downloader = ImageDownloader(photoRecord)
//      //3
//      downloader.completionBlock = {
//        if downloader.isCancelled {
//          return
//        }
//
//        DispatchQueue.main.async {
//          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
//          self.tableView.reloadRows(at: [indexPath], with: .fade)
//        }
//      }
//      //4
//      pendingOperations.downloadsInProgress[indexPath] = downloader
//      //5
//      pendingOperations.downloadQueue.addOperation(downloader)
//    }
    
    

       
   //    func updateItems(updates: [ItemUpdate]) {
   //        collectionView.performBatchUpdates({
   //          for update in updates {
   //              switch update {
   //              case .Add(let index):
   //                  collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
   //                  itemCount += 1
   //              case .Delete(let index):
   //                  collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
   //                  itemCount -= 1
   //              }
   //          }
   //      }, completion: nil)
   //    }
    
    
}

//MARK: Data Source
extension MarsPhotoCollectionVC{
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MarsPhotoCollectionViewCell
        
        guard let imageUrl = roverPhotoObjects[indexPath.row].imageUrl else{return cell}
        cell.marsPhotoUrl = imageUrl
        
        let imageDownloader = ImageDownloader()
        imageDownloader.downloadImageCacheAndAssignToImageView(imageUrl: imageUrl, imageView: cell.marsPhotoImageView)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roverPhotoObjects.count
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
        } else{
            //if user is scrolling too quickly and prefetchItems doesn't return desired index
            
            // calculated the distance from the bottom of the scrollview.
            let distanceFromBottom = collectionView.contentSize.height - (collectionView.bounds.size.height - collectionView.contentInset.bottom) - collectionView.contentOffset.y
            
            // if we are at the bottom of view and above if statement didn't execute
            if distanceFromBottom < 50 {
                getPhotosFromAPI()
            }
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
