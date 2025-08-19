//
//  ApiService.swift
//  Todo-Test
//
//  Created by Islomiddin on 19/08/25.
//

import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        request(url: "https://jsonplaceholder.typicode.com/todos", completion: completion)
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        request(url: "https://jsonplaceholder.typicode.com/users", completion: completion)
    }
    
    private func request<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
