//
//  RoverImageData.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct RoverImageData: Codable{
    var id: Int?
    var sol: Int?
//    var camera
    var imageUrl: String?
    var earthDate: String?
//    var rover
    
    enum CodingKeys: String, CodingKey{
        case id, sol
        case imageUrl = "img_src"
        case earthDate = "earth_date"
    }
    
    init(input: [String: Any]) {
        //        if let entry = dictionary["entry"] as? [String: Any] {
        self.id = input["id"] as? Int
        self.sol = input["sol"] as? Int
        self.earthDate = input["earth_date"] as? String
        self.imageUrl = input["img_src"] as? String
    }
}

struct Wrapper<T: Decodable>: Decodable {
    let photos: [T]
}
