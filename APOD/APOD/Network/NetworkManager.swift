//
//  NetworkManager.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()
    private let urlSession: URLSession

    private let baseURL = "https://api.nasa.gov/"
    private let apiKey = "jYwY9sVIUVaXDnoeFEVefRXlyYoacvMcvpsnmiP8"

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    private func urlRequest<Value>(for request: NetworkRequest<Value>) -> URLRequest {
        let url = URL(baseURL, apiKey, request)
        var result = URLRequest(url: url)
        result.httpMethod = request.method.rawValue
        result.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return result
    }

    func requestData<Value: Decodable>(_ request: NetworkRequest<Value>, completion: @escaping (Result<Value, NetworkError>) -> Void) {
        urlSession.dataTask(with: urlRequest(for: request)) { responseData, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(.failure(.responseError))
                return
            }

            if let data = responseData {
                let response: Value
                do {
                    response = try JSONDecoder().decode(Value.self, from: data)
                } catch {
                    print(error)
                    completion(.failure(.parsingError))
                    return
                }

                completion(.success(response))
            } else {
                completion(.failure(.networkError))
            }
        }.resume()
    }
}

extension URL {
    func url(with queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url!
    }

    init<Value>(_ host: String, _ apiKey: String, _ request: NetworkRequest<Value>) {
        let queryItems = [ ("api_key", apiKey) ]
            .map { name, value in URLQueryItem(name: name, value: "\(value)") }

        let url = URL(string: host)!
            .appendingPathComponent(request.endPoint)
            .url(with: queryItems)

        self.init(string: url.absoluteString)!
    }
}
