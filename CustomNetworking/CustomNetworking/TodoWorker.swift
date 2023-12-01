//
//  TodoWorker.swift
//  CustomNetworking
//
//  Created by Анастасия on 01.12.2023.
//

import Foundation

enum TodoEndpoint: Endpoint {
    case todo(Int)
    
    var compositePath: String {
        switch self {
            
        case .todo(let number):
            "/todos/\(number)"
        }
    }
    
    var headers: HeaderModel { [:] }
}

struct Todo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}

final class TodoWorker {
    typealias todoResult = (Result<Todo, Error>) -> Void
    
    private let networking: Networking = Networking (
        baseUrl: "https://jsonplaceholder.typicode.com"
    )
    
    func fetchTodos(completion: @escaping todoResult) {
        let endpoint = TodoEndpoint.todo(1)
        let request = Request(endpoint: endpoint, method: .get)
        networking.executeRequest(with: request) { result in
            switch result {
                
            case .success(let model):
                if let data = model.data {
                    print(String(data: data, encoding: .utf8))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
