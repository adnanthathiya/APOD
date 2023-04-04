//
//  ApodData.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation
public struct ApodData : Codable {

    var title : String
    var explanation : String
    var url : String
    var mediaType : String
    var copyright : String?
    var date: String
    var imagePath: String?

    enum CodingKeys : String, CodingKey {
        case title
        case explanation
        case url
        case mediaType = "media_type"
        case copyright
        case date
    }
}

extension ApodData {
    static func getApodDataRequest() -> NetworkRequest<ApodData> {
        return NetworkRequest(method: .get, endPoint: .apodData)
    }
}
