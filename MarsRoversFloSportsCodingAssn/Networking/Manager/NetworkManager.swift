//
//  NetworkManager.swift
//
//  price-test
//
//  Created by Suhaib Mahmood on 11/1/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Kingfisher

protocol NetworkManagerProtocol {
    func getRoverPhotos(page: Int, completion: @escaping (Result<[RoverImageData], DataResponseError>)->())
}

struct NetworkManager: NetworkManagerProtocol {
    static let environment : NetworkEnvironment = .production
    static let NasaAPIKey = "7h6pieYU2QhwhpnspamlJt0rvjUpmyrHnxsXaEju"
    let router = Router<MarsRoverNasaApi>()
    
//    func getPhotoFromURL(url: String, ){
////        guard let safeUrlString = marsPhotoUrl else{return}
//        guard let safeUrl = URL(string: safeUrlString) else{return}
//        
//        marsPhotoImageView.kf.setImage(with: safeUrl, placeholder: UIImage(named: "placeholder_image"), options: [.transition(.fade(1))], progressBlock: nil) { [weak self] result in
//            switch result{
//            case .success(let value):
//                if value.source.url != safeUrl{
//                    self?.marsPhotoImageView.image = UIImage(named: "placeholder_image")
//                }
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//            }
//        }
//    }
    
    
    
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
