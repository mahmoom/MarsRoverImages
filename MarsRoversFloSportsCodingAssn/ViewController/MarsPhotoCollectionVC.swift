//
//  ViewController.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class MarsPhotoCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
//    let loadingQueue = OperationQueue()
//    var loadingOperations: [IndexPath: ImageDownloader] = [:]
    
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
    private var isFetchInProgress = false
//    var total = 0
    
    var request: AnyObject?
    var roverPhotoObjects: [RoverImageData] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        collectionView.backgroundColor = .black
        collectionView.register(MarsPhotoCollectionViewCell.self)
        getPhotosFromAPI()
        setupNavBar()
        collectionView?.prefetchDataSource = self
        // Do any additional setup after loading the view.
    }
    
    func setupNavBar(){
        self.title = "Mars Rover Images"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MarsPhotoCollectionViewCell
//        if roverPhotoObjects.count >= indexPath.row + 1 {
//        let photoDetails = roverPhotoObjects[indexPath.row]
        
//        if !collectionView.isDragging && !collectionView.isDecelerating {
//          startDownload(for: photoDetails, at: indexPath)
//        }
        
//            cell.marsPhotoUrl = roverPhotoObjects[indexPath.row].imageUrl
        guard let imageUrl = roverPhotoObjects[indexPath.row].imageUrl else{return cell}
        cell.marsPhotoUrl = imageUrl
        let imageDownloader = ImageDownloader()
        imageDownloader.downloadImageCacheAndAssignToImageView(imageUrl: imageUrl, imageView: cell.marsPhotoImageView)
//        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roverPhotoObjects.count
//        return roverPhotoObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3, height: view.frame.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    
    private func getPhotosFromAPI(networkManager: NetworkManagerProtocol = NetworkManager()){
        
        guard !isFetchInProgress else {
          return
        }

        isFetchInProgress = true
        
        networkManager.getRoverPhotos(page: currentPage) { [weak self] (result) in
            switch result{
            case .success(let photoResults):
//                self?.roverPhotoObjects = photoResults
                DispatchQueue.main.async{
                    self?.currentPage += 1
                    self?.isFetchInProgress = false
                    //                self?.total = photoResults.count
                    self?.roverPhotoObjects.append(contentsOf: photoResults)

                    if self?.currentPage ?? 0 > 1{
                        let indexPathsToReload = self?.calculateIndexPathsToReload(from: photoResults)
                        self?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self?.onFetchCompleted(with: .none)
                    }
                }
            //                self?.roverPhotoObjects = photoResults
            case .failure(let error):
                DispatchQueue.main.async{
                    self?.isFetchInProgress = false
                    //                self?.roverPhotoObjects = nil
                    print(error.reason)
                }
            }
        }
        
//                let roverRequest = APIRequest(resource: RoverResource())
//                request = roverRequest
//                roverRequest.load { [weak self] (roverPhotoData: [RoverImageData]?) in
//                    guard let roverPhotoData = roverPhotoData else {
//                            return
//                    }
//                    self?.roverPhotoObjects = roverPhotoData
//        //            DispatchQueue.global(qos: .utility).async {
//        //                roverPhotoData.forEach({ (roverObject) in
//        //                    <#code#>
//        //                })
//        //            }
//                }
    }
    
    private func calculateIndexPathsToReload(from newMarsPhotos: [RoverImageData]) -> [IndexPath]? {
        //        guard let roverPhotoObj = roverPhotoObjects else{return nil}
        let startIndex = roverPhotoObjects.count - newMarsPhotos.count
        let endIndex = startIndex + newMarsPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            collectionView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) {
        activityIndicator.stopAnimating()
        
        let title = "Warning"
//        let action = UIAlertAction(title: "OK", style: .default)
        Alert.showBasic(title: title, message: "OK", vc: self)
//        displayAlert(with: title , message: reason, actions: [action])
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension MarsPhotoCollectionVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("Row is: ", indexPaths, " Count is: ", roverPhotoObjects.count)
//        let urls = indexPaths.flatMap { URL(string: $0.) }
        //        let urls = indexPaths.flatMap { URL(string: $0.urlString) }
        //        ImagePrefetcher(urls: urls).start()
        if indexPaths.contains(where: isLoadingCell) {
//          viewModel.fetchModerators()
            getPhotosFromAPI()
        } else{
//            let minimumTrigger = collectionView.bounds.size.height - 50
            //if use is scrolling too quickly and prefetchItems doesn't return desired index
            // verify view of scroll is larger than min height required for trigger
            // this ensures load more results isn't contstantly called (infinitely)
//            if collectionView.contentSize.height > minimumTrigger {

                // calculated the distance from the bottom of the scrollview.
                let distanceFromBottom = collectionView.contentSize.height - (collectionView.bounds.size.height - collectionView.contentInset.bottom) - collectionView.contentOffset.y

                // crucial check.
                if distanceFromBottom < 50 {
                    getPhotosFromAPI()
                }
//            }
        }
    }
    
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

private extension MarsPhotoCollectionVC {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    //since we are showing 3 items per row, we want to start loading as we near the end of the scroll
    let count = roverPhotoObjects.count - 6//(roverPhotoObjects.count % 3)
    return indexPath.row >= count
//    print("Row is: ", indexPath.row, " Count is: ", count)
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems // indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
    return Array(indexPathsIntersection)
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
    
    
   
    
    
}
