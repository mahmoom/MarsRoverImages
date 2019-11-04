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

enum CuriosityCameras: String, CaseIterable {
    case FHAZ, RHAZ, MAST, CHEMCAM, MAHLI, MARDI, NAVCAM, NONE
}
enum SpiritOpportunityCameras: String, CaseIterable {
    case FHAZ, RHAZ, NAVCAM, PANCAM, MINITES, NONE
}
enum AllCameras: String, CaseIterable{
    case FHAZ, RHAZ, MAST, CHEMCAM, MAHLI, MARDI, NAVCAM, PANCAM, MINITES, NONE
}

extension Camera: Codable {
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}
