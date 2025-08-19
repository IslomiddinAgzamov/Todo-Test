//
//  TodoDetailViewController.swift
//  Todo-Test
//
//  Created by Islomiddin on 19/08/25.
//

import UIKit

final class TodoDetailViewController: UIViewController {
    private let item: TodoItem
    
    init(item: TodoItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
        Title: \(item.todo.title)
        Completed: \(item.todo.completed)
        
        User: \(item.user.name)
        Email: \(item.user.email)
        """
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

