//
//  Rover.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Rover: Codable{
    var name: String?
}

enum Rovers: String, CaseIterable {
    case curiosity, spirit, opportunity
}

extension Rover: Equatable {
    static func == (lhs: Rover, rhs: Rover) -> Bool {
        return lhs.name == rhs.name
    }
}
