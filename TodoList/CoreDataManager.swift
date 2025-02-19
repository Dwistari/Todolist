//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Dwistari on 18/02/25.
//

import CoreData
import RxSwift


class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskData")
        persistentContainer.loadPersistentStores {_,error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext(name: String, date: Date) -> Single<Void> {
        let newTask = Todo(context: context)
        newTask.name = name
        newTask.date = date
        return Single.create { [self] single in
            do {
                try context.save()
                single(.success(()))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func loadTodos(on date: Date) -> Single<[Todo]> {
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
        let fetchRequest = Todo.fetchRequest()
        fetchRequest.predicate = predicate
        
        return Single.create { [self] single in
            do {
                let todos = try context.fetch(fetchRequest)
                single(.success((todos)))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    
    func removeTodo(id: NSManagedObjectID) -> Completable {
        return Completable.create { [self] completable in
            do {
                let todo =  try context.existingObject(with: id)
                context.delete(todo)
                try context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
