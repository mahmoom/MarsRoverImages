//
//  NetworkManager.swift
//
//  price-test
//
//  Created by Suhaib Mahmood on 11/1/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func getRoverPhotos(page: Int, completion: @escaping (Result<[RoverImageData], DataResponseError>)->())
    func getCuriosityPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->())
    func getOpportunityPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->())
    func getSpiritPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->())
}

struct NetworkManager: NetworkManagerProtocol {
    static let environment : NetworkEnvironment = .production
    static let NasaAPIKey = "7h6pieYU2QhwhpnspamlJt0rvjUpmyrHnxsXaEju"
    let router = Router<MarsRoverNasaApi>()
    
    //couldn't come up with a good way to not duplicate code here, the networking layer is great for handling different paths that take different parameters, but not so good at handling when the paths are different but the parameters and reponses are the same :(
    func getOpportunityPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
        router.request(.opportunity(page: page, camera: camera, earthDate: earthDate)) { (data, response, error) in
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
    
    func getSpiritPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
        router.request(.spirit(page: page, camera: camera, earthDate: earthDate)) { (data, response, error) in
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
    
    func getCuriosityPhotos(page: Int, camera: String?, earthDate: String, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
        router.request(.curiosity(page: page, camera: camera, earthDate: earthDate)) { (data, response, error) in
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
    
    
    func getRoverPhotos(page: Int, completion: @escaping (Result<[RoverImageData], DataResponseError>)->()){
        router.request(.page(page: page)) { data, response, error in
            
            if error != nil {
                completion(.failure(.network))
            }
            guard let response = response as? HTTPURLResponse,
                response.hasSuccessStatusCode else{
                    completion(.failure(.network))
                    return
            }
            guard let responseData = data else {
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
}
