//
//  RoverImageData.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

struct RoverImageData{
    var id: Int?
    var sol: Int?
    var camera: Camera?
    var imageUrl: String?
    var earthDate: String?
    var rover: Rover?
}

extension RoverImageData: Codable{
    enum CodingKeys: String, CodingKey{
        case id, sol, camera, rover
        case imageUrl = "img_src"
        case earthDate = "earth_date"
    }
}



struct Wrapper<T: Decodable>: Decodable {
    let photos: [T]
}
