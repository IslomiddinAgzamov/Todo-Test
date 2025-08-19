//
//  TodoListViewModel.swift
//  Todo-Test
//
//  Created by Islomiddin on 19/08/25.
//

import Foundation
import Network

final class TodoListViewModel {
    private var allTodos: [TodoItem] = []
    private var filteredTodos: [TodoItem] = []
    private(set) var displayedTodos: [TodoItem] = []
    
    private let monitor = NWPathMonitor()
    private let pageSize = 20
    private var currentPage = 0
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchData() {
        if !isConnectedToInternet(), let cached = CacheManager().load() {
            self.allTodos = cached
            self.filteredTodos = cached
            loadNextPage()
            return
        }
        
        let group = DispatchGroup()
        var todos: [Todo] = []
        var users: [User] = []
        var fetchError: Error?
        
        group.enter()
        APIService.shared.fetchTodos { result in
            if case .success(let t) = result { todos = t }
            else if case .failure(let e) = result { fetchError = e }
            group.leave()
        }
        
        group.enter()
        APIService.shared.fetchUsers { result in
            if case .success(let u) = result { users = u }
            else if case .failure(let e) = result { fetchError = e }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                self.onError?(error.localizedDescription)
                return
            }
            
            let merged = todos.compactMap { todo -> TodoItem? in
                guard let user = users.first(where: { $0.id == todo.userId }) else { return nil }
                return TodoItem(todo: todo, user: user)
            }
            
            self.allTodos = merged
            self.filteredTodos = merged
            CacheManager().save(merged)
            
            self.currentPage = 0
            self.displayedTodos.removeAll()
            self.loadNextPage()
        }
    }
    
    func loadNextPage() {
        guard currentPage * pageSize < filteredTodos.count else { return }
        let start = currentPage * pageSize
        let end = min(start + pageSize, filteredTodos.count)
        displayedTodos.append(contentsOf: filteredTodos[start..<end])
        currentPage += 1
        onUpdate?()
    }
    
    func search(query: String) {
        if query.isEmpty {
            filteredTodos = allTodos
        } else {
            filteredTodos = allTodos.filter {
                $0.todo.title.lowercased().contains(query.lowercased()) ||
                $0.user.name.lowercased().contains(query.lowercased())
            }
        }
        currentPage = 0
        displayedTodos.removeAll()
        loadNextPage()
    }
    
    private func isConnectedToInternet() -> Bool {
        var status: Bool = false
        monitor.pathUpdateHandler =  { path in
            status = path.status == .satisfied
        }
        
        return status
    }
}

#if DEBUG
extension TodoListViewModel {
    func testInjectData(_ todos: [TodoItem]) {
        allTodos = todos
        filteredTodos = todos
        displayedTodos.removeAll()
        currentPage = 0
    }
}
#endif
