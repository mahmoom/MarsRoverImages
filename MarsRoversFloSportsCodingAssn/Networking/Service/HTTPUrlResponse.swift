//
//  HTTPUrlResponse.swift
//  price-test
//
//  Created by Suhaib Mahmood on 10/31/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
