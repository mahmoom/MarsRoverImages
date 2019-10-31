//
//  ViewController.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MarsPhotoCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    struct Constants{
//        static let marsPhotoCellID = "marsPhotoCellID"
//    }
    
    var request: AnyObject?
    var roverPhotoObjects: [RoverImageData]?{
        didSet{
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blue
        collectionView.register(MarsPhotoCollectionViewCell.self)
        getPhotosFromAPI()
        
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
    
    private func getPhotosFromAPI(){
        let roverRequest = APIRequest(resource: RoverResource())
        request = roverRequest
        roverRequest.load { [weak self] (roverPhotoData: [RoverImageData]?) in
            guard let roverPhotoData = roverPhotoData else {
                    return
            }
            self?.roverPhotoObjects = roverPhotoData
//            DispatchQueue.global(qos: .utility).async {
//                roverPhotoData.forEach({ (roverObject) in
//                    <#code#>
//                })
//            }
        }
    }


}

