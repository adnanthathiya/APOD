//
//  NetworkRequest.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation

enum Method: String {
    case get = "GET"
}

enum Endpoint: String {
    case apodInfo = "planetary/apod"
}

struct NetworkRequest<Value> {
    var method: Method
    var endPoint: String

    init(method: Method = .get, endPoint: Endpoint) {
        self.method = method
        self.endPoint = endPoint.rawValue
    }
}
