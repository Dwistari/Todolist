//
//  TodoStorage.swift
//  TodoList
//
//  Created by Dwistari on 17/02/25.
//

import Foundation
import RxSwift

class TodoStorage {
    static let todosKey = "todos"

    static func saveTodos(_ todos: [String]) -> Completable {
        return Completable.create { completable in
            UserDefaults.standard.set(todos, forKey: self.todosKey)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    static func loadTodos() -> Single<[String]> {
        return Single.create { single in
            let todos = UserDefaults.standard.stringArray(forKey: self.todosKey) ?? []
            single(.success(todos))
            return Disposables.create()
        }
    }
    
    static func removeTodo(at index: Int) -> Completable {
        return Completable.create { completable in
            var todos = UserDefaults.standard.stringArray(forKey: self.todosKey) ?? []
            if index >= 0 && index < todos.count {
                todos.remove(at: index)
                UserDefaults.standard.set(todos, forKey: self.todosKey)
                completable(.completed)
            }
            return Disposables.create()
        }
    }
}

