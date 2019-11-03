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
    
//    var request: AnyObject?
    var roverPhotoObjects: [RoverImageData]?{
        didSet{
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        collectionView.register(MarsPhotoCollectionViewCell.self)
        getPhotosFromAPI()
        
        collectionView?.prefetchDataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MarsPhotoCollectionViewCell
        if roverPhotoObjects?.count ?? -1 >= indexPath.row + 1 {
            cell.marsPhotoUrl = roverPhotoObjects?[indexPath.row].imageUrl
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roverPhotoObjects?.count ?? 6
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
    
    private func getPhotosFromAPI(networkManager: NetworkManagerProtocol = NetworkManager()){
        
        networkManager.getRoverPhotos(page: 1) { [weak self] (result) in
            switch result{
            case .success(let photoResults):
                self?.roverPhotoObjects = photoResults
            case .failure(let error):
                self?.roverPhotoObjects = nil
                print(error.reason)
            }
        }
        
//        let roverRequest = APIRequest(resource: RoverResource())
//        request = roverRequest
//        roverRequest.load { [weak self] (roverPhotoData: [RoverImageData]?) in
//            guard let roverPhotoData = roverPhotoData else {
//                    return
//            }
//            self?.roverPhotoObjects = roverPhotoData
////            DispatchQueue.global(qos: .utility).async {
////                roverPhotoData.forEach({ (roverObject) in
////                    <#code#>
////                })
////            }
//        }
    }

    private func calculateIndexPathsToReload(from newMarsPhotos: [RoverImageData]) -> [IndexPath]? {
        guard let roverPhotoObj = roverPhotoObjects else{return nil}
        let startIndex = roverPhotoObj.count - newMarsPhotos.count
        let endIndex = startIndex + newMarsPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

}

extension MarsPhotoCollectionVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let urls = indexPaths.flatMap { URL(string: $0.urlString) }
//        ImagePrefetcher(urls: urls).start()
    }
}
