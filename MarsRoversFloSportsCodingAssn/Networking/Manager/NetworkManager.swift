//
//  NetworkManager.swift
//
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 11/1/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func getRoverPhotos(page: Int, earthDate: String, rover: String, camera: String?, completion: @escaping (Result<[RoverImageData], DataResponseError>)->())
}

struct NetworkManager: NetworkManagerProtocol {
    static let environment : NetworkEnvironment = .production
    static let NasaAPIKey = "7h6pieYU2QhwhpnspamlJt0rvjUpmyrHnxsXaEju"
    let router = Router<MarsRoverNasaApi>()
    
    func getRoverPhotos(page: Int, earthDate: String, rover: String, camera: String?, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
        router.request(.rover(page: page, camera: camera, earthDate: earthDate, rover: rover)) { (data, response, error) in
            if error != nil {
                completion(.failure(.network))
            }
            guard let response = response as? HTTPURLResponse,
                response.hasSuccessStatusCode, let responseData = data else{
                    completion(.failure(.network))
                    return
            }
            do {
                let apiResponse = try JSONDecoder().decode(Wrapper<RoverImageData>.self, from: responseData)
                completion(.success(apiResponse.photos))
            }catch {
                completion(.failure(.decoding))
            }
        }
    }
    
    
//    func getRoverPhotos(page: Int, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
//        router.request(.page(page: page)) { data, response, error in
//            
//            if error != nil {
//                completion(.failure(.network))
//            }
//            guard let response = response as? HTTPURLResponse,
//                response.hasSuccessStatusCode else{
//                    completion(.failure(.network))
//                    return
//            }
//            guard let responseData = data else {
//                completion(.failure(.network))
//                return
//            }
//            do {
//                let apiResponse = try JSONDecoder().decode(Wrapper<RoverImageData>.self, from: responseData)
//                completion(.success(apiResponse.photos))
//            }catch {
//                completion(.failure(.decoding))
//            }
//            
//        }
//    }
}
