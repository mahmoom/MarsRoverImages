//
//  MarsDetailPhotoViewModel.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/3/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct MarsDetailPhotoViewModel {
    var idLabelText: String!
    var eartDateLabelText: String!
    var solLabelText: String!
    var roverLabelText: String!
    var cameraLabelText: String!
    
    init(roverData: RoverImageData) {
        if let id = roverData.id{
            self.idLabelText = "id: " + (String(id))
        } else {
            self.idLabelText = "id: "
        }
        
        if let sol = roverData.sol{
            self.solLabelText = "sol: " + (String(sol))
        } else {
            self.idLabelText = "sol: "
        }
        
        self.eartDateLabelText = "Earth Date: " + (roverData.earthDate ?? "")
        self.roverLabelText = "Rover Name: " + (roverData.rover?.name ?? "")
        self.cameraLabelText = "Camera: " + (roverData.camera?.fullName ?? "")
    }
}
