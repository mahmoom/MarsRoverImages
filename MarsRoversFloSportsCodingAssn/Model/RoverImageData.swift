//
//  RoverImageData.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

struct RoverImageData: Codable{
    var id: Int?
    var sol: Int?
    var camera: Camera?
    var imageUrl: String?
    var earthDate: String?
    var rover: Rover?
    
    enum CodingKeys: String, CodingKey{
        case id, sol, camera, rover
        case imageUrl = "img_src"
        case earthDate = "earth_date"
    }
}

struct Camera: Codable{
    var fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

struct Rover: Codable{
    var name: String?
}

struct Wrapper<T: Decodable>: Decodable {
    let photos: [T]
}
