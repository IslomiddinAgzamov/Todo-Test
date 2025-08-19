//
//  Todo_TestTests.swift
//  Todo-TestTests
//
//  Created by Islomiddin on 19/08/25.
//

import XCTest
@testable import Todo_Test

final class TodoListViewModelTests: XCTestCase {
    
    private var viewModel: TodoListViewModel!
    private var todos: [TodoItem] = []
    
    override func setUp() {
        super.setUp()
        viewModel = TodoListViewModel()
        
        // Mock data
        let users = (1...5).map { User(id: $0, name: "User\($0)", username: "u\($0)", email: "u\($0)@mail.com") }
        todos = (1...50).map {
            TodoItem(
                todo: Todo(id: $0, userId: ($0 % 5) + 1, title: "Todo \($0)", completed: $0 % 2 == 0),
                user: users[($0 % 5)]
            )
        }
        
        viewModel.testInjectData(todos)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialPaginationLoads20Items() {
        viewModel.loadNextPage()
        XCTAssertEqual(viewModel.displayedTodos.count, 20)
    }
    
    func testPaginationLoadsNextPage() {
        viewModel.loadNextPage()
        viewModel.loadNextPage()
        XCTAssertEqual(viewModel.displayedTodos.count, 40)
    }
    
    func testPaginationDoesNotExceedLimit() {
        for _ in 0..<10 { viewModel.loadNextPage() }
        XCTAssertEqual(viewModel.displayedTodos.count, todos.count)
    }
    
    func testSearchFiltersByTitle() {
        viewModel.search(query: "Todo 1")
        XCTAssertTrue(viewModel.displayedTodos.allSatisfy { $0.todo.title.contains("1") })
    }
    
    func testSearchFiltersByUserName() {
        viewModel.search(query: "User1")
        XCTAssertTrue(viewModel.displayedTodos.allSatisfy { $0.user.name == "User1" })
    }
}
