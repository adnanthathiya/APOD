//
//  NetworkError.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation

enum NetworkError: Error {
    case responseError
    case unknown
    case parsingError
    case networkError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        case .parsingError:
            return NSLocalizedString("Data Parsing Error", comment: "Data Parsing Error")
        case .networkError:
            return NSLocalizedString("Network Error", comment: "Network Error")
        }
    }
}
