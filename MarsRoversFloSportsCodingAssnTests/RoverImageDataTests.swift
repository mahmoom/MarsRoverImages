//
//  RoverImageDataTests.swift
//  MarsRoversFloSportsCodingAssnTests
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
@testable import MarsRoversFloSportsCodingAssn

class RoverImageDataTests: XCTestCase {
    
    var roverImageData: RoverImageData!

    var pharmacy: RoverImageData!
    override func setUp() {
        let camera = Camera(fullName: "MHAZ")
        let rover = Rover(name: "curiosity")
        roverImageData = RoverImageData(id: 10, sol: 1000, camera: camera, imageUrl: nil, earthDate: Constants.defaultEarthDate, rover: rover)
    }


    func testCamera(){
        XCTAssertEqual(Camera(fullName: "MHAZ"), roverImageData.camera, "Name should match")
    }
    
}
