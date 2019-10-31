//
//  NetworkController.swift
//  MarsRoversFloSportsCodingAssn
//
//  Created by Suhaib Mahmood on 10/30/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
//            print(url)
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: [])  else{
//                print("MAJOR FAIL")
//                return
//            }
//            print(json)
            completion(self?.decode(data))
        })
        task.resume()
    }
}

class ImageRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ImageRequest: NetworkRequest {
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func load(withCompletion completion: @escaping (UIImage?) -> Void) {
        load(url, withCompletion: completion)
    }
}

class APIRequest<Resource: APIResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> [Resource.ModelType]? {
//        print(data)
//        guard let json = try? JSONSerialization.data(withJSONObject: data, options: []) as? [[String: AnyObject]] else{
//            print("MAJOR FAIL")
//            return []
//        }
//        return []
//        print(json)
//        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
//            print("MAJOR FAIL")
//            return []
//        }
////        print(json["photos"])
////        print(test)
//        guard let testArray = json["photos"] as? [[String: Any]] else{
//            print("FAILED AAAGAIN")
//            return []
//        }
//        let test = testArray.compactMap{RoverImageData(input: $0)}
//        print(test)
        let wrapper = try? JSONDecoder().decode(Wrapper<Resource.ModelType>.self, from: data)
//        print(wrapper?.photos)
        return wrapper?.photos
        
//        let wrapper = try? JSONDecoder().decode(Resource.ModelType.self, from: data)
//        print(wrapper)
//        return []
    }
    
    func load(withCompletion completion: @escaping ([Resource.ModelType]?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}

protocol APIResource {
    associatedtype ModelType: Decodable
//    var methodPath: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIResource {
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = "/mars-photos/api/v1/rovers/curiosity/photos"
        components.queryItems = queryItems//[
//            URLQueryItem(name: "sol", value: "1000"),
////            URLQueryItem(name: "camera", value: ""),
//            URLQueryItem(name: "page", value: "1"),
//            URLQueryItem(name: "api_key", value: "7h6pieYU2QhwhpnspamlJt0rvjUpmyrHnxsXaEju")
//        ]
        return components.url!
    }
}

struct RoverResource: APIResource {
    var queryItems: [URLQueryItem]
    
    typealias ModelType = RoverImageData
//    let typeOfDay: typeOfDay
//    let page: Int
//    let camera: camera?
    
    
    init(typeOfDay: typeOfDay = .sol, page: Int = 1, camera: camera? = nil) {
//        self.typeOfDay = typeOfDay
//        self.page = page
        
        if let selectedCamera = camera{
            
            queryItems = [
                URLQueryItem(name: "sol", value: "1000"),
                URLQueryItem(name: "camera", value: selectedCamera.rawValue),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "api_key", value: "7h6pieYU2QhwhpnspamlJt0rvjUpmyrHnxsXaEju")
            ]
        } else{
            queryItems = [
                URLQueryItem(name: "sol", value: "1000"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: "7h6pieYU2QhwhpnspamlJt0rvjUpmyrHnxsXaEju")
            ]
        }
    }
}

extension RoverResource{
    enum typeOfDay: String {
        case sol
        case earth = "earth_date"
    }
    enum camera: String {
        case FHAZ, RHAZ, MAST, CHEMCAM, MAHLI, MARDI, NAVCAM, PANCAM, MINITES
    }
}

//enum Result <T>{
//    case Success(T)
//    case Error(ItunesApiError)
//}
//
//enum ItunesApiError: Error {
//    case requestFailed
//    case jsonConversionFailure
//    case invalidData
//    case responseUnsuccessful
//    case invalidURL
//    case jsonParsingFailure
//}
