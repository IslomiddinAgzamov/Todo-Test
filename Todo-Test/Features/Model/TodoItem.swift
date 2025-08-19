//
//  TodoItem.swift
//  Todo-Test
//
//  Created by Islomiddin on 19/08/25.
//

import Foundation

struct TodoItem {
    let todo: Todo
    let user: User
}

struct Todo: Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
