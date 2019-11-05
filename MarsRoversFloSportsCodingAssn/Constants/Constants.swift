//
//  Constants.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/4/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Constants {
    static let defaultEarthDate = "2015-05-30"
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

enum Rovers: String, CaseIterable {
    case curiosity, spirit, opportunity
}
