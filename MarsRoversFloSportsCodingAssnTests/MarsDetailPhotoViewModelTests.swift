//
//  MarsDetailPhotoViewModelTests.swift
//  MarsRoversFloSportsCodingAssnTests
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
@testable import MarsRoversFloSportsCodingAssn

class MarsDetailPhotoViewModelTests: XCTestCase {

    var marsDetailViewModel: MarsDetailPhotoViewModel!
    var roverImageData: RoverImageData!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let camera = Camera(fullName: "MHAZ")
        let rover = Rover(name: "curiosity")
        roverImageData = RoverImageData(id: 10, sol: 1000, camera: camera, imageUrl: nil, earthDate: Constants.defaultEarthDate, rover: rover)
        marsDetailViewModel = MarsDetailPhotoViewModel(roverData: roverImageData)
    }
    
    func testViewModelCameraLabelText(){
        XCTAssertEqual(marsDetailViewModel.cameraLabelText, "Camera: MHAZ")
    }
    func testViewModelSolLabelText(){
        XCTAssertEqual(marsDetailViewModel.solLabelText, "sol: 1000")
    }
    func testViewModelRoverLabelText(){
        XCTAssertEqual(marsDetailViewModel.roverLabelText, "Rover Name: curiosity")
    }
    func testViewModelEarthDateLabelText(){
        XCTAssertEqual(marsDetailViewModel.earthDateLabelText, "Earth Date: 2015-05-30")
    }
    func testViewModelIdLabelText(){
        XCTAssertEqual(marsDetailViewModel.idLabelText, "id: 10")
    }
    
    func testViewModelCameraLabelTextNil(){
        let emptyModel = RoverImageData(id: nil, sol: nil, camera: nil, imageUrl: nil, earthDate: nil, rover: nil)
        let emptyViewModel = MarsDetailPhotoViewModel(roverData: emptyModel)
        XCTAssertEqual(emptyViewModel.cameraLabelText, "Camera: ")
    }
    func testViewModelSolLabelTextNil(){
        let emptyModel = RoverImageData(id: nil, sol: nil, camera: nil, imageUrl: nil, earthDate: nil, rover: nil)
        let emptyViewModel = MarsDetailPhotoViewModel(roverData: emptyModel)
        XCTAssertEqual(emptyViewModel.solLabelText, "sol: ")
    }
    func testViewModelRoverLabelTextNil(){
        let emptyModel = RoverImageData(id: nil, sol: nil, camera: nil, imageUrl: nil, earthDate: nil, rover: nil)
        let emptyViewModel = MarsDetailPhotoViewModel(roverData: emptyModel)
        XCTAssertEqual(emptyViewModel.roverLabelText, "Rover Name: ")
    }
    func testViewModelEarthDateLabelTextNil(){
        let emptyModel = RoverImageData(id: nil, sol: nil, camera: nil, imageUrl: nil, earthDate: nil, rover: nil)
        let emptyViewModel = MarsDetailPhotoViewModel(roverData: emptyModel)
        XCTAssertEqual(emptyViewModel.earthDateLabelText, "Earth Date: ")
    }
    func testViewModelIdLabelTextNil(){
        let emptyModel = RoverImageData(id: nil, sol: nil, camera: nil, imageUrl: nil, earthDate: nil, rover: nil)
        let emptyViewModel = MarsDetailPhotoViewModel(roverData: emptyModel)
        XCTAssertEqual(emptyViewModel.idLabelText, "id: ")
    }
    
}
