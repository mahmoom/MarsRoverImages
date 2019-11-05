//
//  MarsPhotoCollectionVCTests.swift
//  MarsRoversFloSportsCodingAssnTests
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
import Foundation
@testable import MarsRoversFloSportsCodingAssn

class MarsPhotoCollectionVCTests: XCTestCase {

    var marsPhotoCollectionVC: MarsPhotoCollectionVC!
    var mockNetwork: MockNetwork!
    
    override func setUp() {
        super.setUp()
        
        marsPhotoCollectionVC = MarsPhotoCollectionVC(collectionViewLayout: UICollectionViewFlowLayout())
        let _ = marsPhotoCollectionVC.view
        marsPhotoCollectionVC.roverPhotoObjects = [RoverImageData]()
        
        
        for _ in 0..<20 {
            let camera = Camera(fullName: "MHAZ")
            let rover = Rover(name: "curiosity")
            let roverImageData = RoverImageData(id: 10, sol: 1000, camera: camera, imageUrl: nil, earthDate: Constants.defaultEarthDate, rover: rover)
            
            marsPhotoCollectionVC?.roverPhotoObjects.append(roverImageData)
        }
    }
    
    override func tearDown() {
        marsPhotoCollectionVC = nil
    }
    
    func testDataSourceHasPhotoObjects() {
        XCTAssertEqual(marsPhotoCollectionVC.roverPhotoObjects.count, 20,
                       "DataSource should have correct number of photo objects")
    }
    

    func testNumberOfRows() {
        let numberOfRows = marsPhotoCollectionVC.collectionView.numberOfItems(inSection: 0)
        XCTAssertEqual(numberOfRows, 20,
                       "Number of items in table should match number of photo objects")
    }



    func testFetchPhotos(){
        marsPhotoCollectionVC.isFetchInProgress = false
        let mockService = MockNetwork()
        var roverPhotoObjectsBeforeAppend = marsPhotoCollectionVC.roverPhotoObjects
        //perform network call to update roverPhotoObjects datasource
        marsPhotoCollectionVC.getPhotosFromAPI(networkManager: mockService)
        //rover photos should be updated
        roverPhotoObjectsBeforeAppend.append(contentsOf: mockService.result)
        XCTAssertEqual(roverPhotoObjectsBeforeAppend, marsPhotoCollectionVC.roverPhotoObjects)
    }
    

    struct MockNetwork: NetworkManagerProtocol {
        
        var result = [RoverImageData(id: 10, sol: 1000, camera: Camera(fullName: "MHAZ"), imageUrl: nil, earthDate: Constants.defaultEarthDate, rover: Rover(name: "curiosity")), RoverImageData(id: 10, sol: 1000, camera: Camera(fullName: "MHAZ"), imageUrl: nil, earthDate: Constants.defaultEarthDate, rover: Rover(name: "curiosity"))]
        
        func getRoverPhotos(page: Int, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
            completion(.success(result))
        }
        func getCuriosityPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
            completion(.success(result))
        }
        func getOpportunityPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
            completion(.success(result))
        }
        func getSpiritPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
            completion(.success(result))
        }
    }
}
