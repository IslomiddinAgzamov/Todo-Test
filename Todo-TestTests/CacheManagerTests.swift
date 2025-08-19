//
//  CacheManagerTests.swift
//  Todo-TestTests
//
//  Created by Islomiddin on 20/08/25.
//

import XCTest
@testable import Todo_Test

final class CacheManagerTests: XCTestCase {
    
    private var cacheManager: CacheManager!
    private var tempTodos: [TodoItem]!
    
    override func setUp() {
        super.setUp()
        cacheManager = CacheManager()
        
        let user = User(id: 1, name: "John Doe", username: "jdoe", email: "john@mail.com")
        let todo = Todo(id: 1, userId: 1, title: "Test Todo", completed: false)
        tempTodos = [TodoItem(todo: todo, user: user)]
    }
    
    override func tearDown() {
        cacheManager = nil
        tempTodos = nil
        super.tearDown()
    }
    
    func testSaveAndLoadTodos() {
        cacheManager.save(tempTodos)
        let loaded = cacheManager.load()
        
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.todo.title, "Test Todo")
        XCTAssertEqual(loaded?.first?.user.name, "John Doe")
    }
}
