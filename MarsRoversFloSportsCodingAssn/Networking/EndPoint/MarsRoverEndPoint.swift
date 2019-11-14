//
//  MarsRoverEndPoint.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/1/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation


enum NetworkEnvironment {
    case production
}



public enum MarsRoverNasaApi {
    case page(page: Int)
    case rover(page: Int, camera: String?, earthDate: String, rover: String)
    case def
}

extension MarsRoverNasaApi: EndPointType {
    var environmentBaseURL : String {
        switch NetworkManager.environment {
            default: return "https://api.nasa.gov/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .rover(_, _, _, let rover):
            return "mars-photos/api/v1/rovers/\(rover)/photos"
        default:
            return "mars-photos/api/v1/rovers/curiosity/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        
        func generateParams(page: Int, earthDate: String = Constants.defaultEarthDate, camera: String?) -> Parameters{
            var params = Parameters()
            params["earth_date"] = earthDate
            if let safeCamera = camera{
                params["camera"] = safeCamera
            }
            params["page"] = page
            params["api_key"] = NetworkManager.NasaAPIKey
            return params
        }
        switch self {
            //the original case with default params
        case .page(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "sol":1000, "api_key":NetworkManager.NasaAPIKey])
            
        case .rover(let page, let camera, let earthDate, _):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: generateParams(page: page, earthDate: earthDate, camera: camera))
        default:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key":NetworkManager.NasaAPIKey])
        }
        
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


