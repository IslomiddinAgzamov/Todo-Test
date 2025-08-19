//
//  CacheManager.swift
//  Todo-Test
//
//  Created by Islomiddin on 19/08/25.
//

import Foundation

final class CacheManager {
    private let fileName = "todos_cache.json"
    
    private var fileURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }
    
    func save(_ todos: [TodoItem]) {
        do {
            let data = try JSONEncoder().encode(todos.map { CacheTodo(todo: $0.todo, user: $0.user) })
            try data.write(to: fileURL)
        } catch {
            print("Cache save error:", error)
        }
    }
    
    func load() -> [TodoItem]? {
        do {
            let data = try Data(contentsOf: fileURL)
            let cached = try JSONDecoder().decode([CacheTodo].self, from: data)
            return cached.map { TodoItem(todo: $0.todo, user: $0.user) }
        } catch {
            print("Cache load error:", error)
            return nil
        }
    }
}

private struct CacheTodo: Codable {
    let todo: Todo
    let user: User
}
