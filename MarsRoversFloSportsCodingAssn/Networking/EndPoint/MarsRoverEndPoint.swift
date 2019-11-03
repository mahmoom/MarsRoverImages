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
        default:
            return "mars-photos/api/v1/rovers/curiosity/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .page(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "sol":1000, "api_key":NetworkManager.NasaAPIKey])
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


