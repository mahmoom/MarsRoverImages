//
//  DataResponseError.swift
//  price-test
//
//  Created by Suhaib Mahmood on 10/31/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

enum DataResponseError: Error {
    case network
    case decoding
    case badUrl
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data "
        case .decoding:
            return "An error occurred while decoding data"
        case .badUrl:
            return "Url was formatted incorrectly"
        }
    }
}
