//
//  Camera.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Camera{
    var fullName: String?
}

extension Camera: Codable {
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

extension Camera: Equatable {
    static func == (lhs: Camera, rhs: Camera) -> Bool {
        return lhs.fullName == rhs.fullName
    }
}
