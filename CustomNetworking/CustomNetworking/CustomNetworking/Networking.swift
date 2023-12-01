//
//  Networking.swift
//  CustomNetworking
//
//  Created by Анастасия on 01.12.2023.
//

import Foundation

protocol NetworkingProtocol {
    typealias NetworkingResult = (
        (_ result: Result<NetworkingCommandModels.NetworkingResult, Error>) -> Void
    )
    
    func executeRequest(with request: Request, completion: @escaping NetworkingResult)
}

final class Networking: NetworkingProtocol {
    var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func executeRequest(with request: Request, completion: @escaping NetworkingResult) {
        guard let urlRequest = convert(request) else {
            NSLog("wrong url")
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(NetworkingCommandModels.NetworkingResult(data: data, response: response)))
        }
        task.resume()
    }
    
    private func convert(_ request: Request) -> URLRequest? {
        guard let url = generateDestinationURL(for: request) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.endpoint.headers
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        return urlRequest
    }
    
    private func generateDestinationURL(for request: Request) -> URL? {
        guard
            let url = URL(string: baseUrl),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }
        
        let queryItems = request.parameters?.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        components.path += request.endpoint.compositePath
        components.queryItems = queryItems
        
        return components.url
    }
    
}
