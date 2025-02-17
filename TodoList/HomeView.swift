//
//  Home.swift
//  TodoList
//
//  Created by Dwistari on 17/02/25.
//

import SwiftUI
import RxSwift

struct HomeView: View {
    @State private var input = ""
    @State private var tasks: [String] = []
    let disposeBag = DisposeBag()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Input your task", text: $input)
                    .padding()
                    .border(Color.gray)
                    .padding(.leading, 10)
                Button("Add") {
                    tasks.append(input)
                    TodoStorage.saveTodos(tasks)
                        .subscribe(
                            onCompleted: {
                                print("Todos saved successfully!")
                            },
                            onError: { error in
                                print("Failed to save todos: \(error)")
                            }
                        )
                        .dispose()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(width: 100, height: 100)
            }
            
            List {
                ForEach(Array(tasks.enumerated()), id: \.element) { index, task in
                    TaskRow(taskName: task, didRemoveTodo: {
                        print("didRemoveTodo")
                      removeTask(at: index)
                    })
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .onAppear{
            loadTasks()
        }
        
    }
    
    private func loadTasks() {
        TodoStorage.loadTodos()
            .subscribe(
                onSuccess: { todos in
                    tasks = todos
                    print("Loaded todos: \(todos)")
                },
                onFailure: { error in
                    print("Failed to load todos: \(error)")
                }
                
            )
            .disposed(by: disposeBag)
    }
    
    private func removeTask(at index: Int) {
        TodoStorage.removeTodo(at: index)
            .subscribe(
                onCompleted: {
                    print("Todos removed successfully!")
                    loadTasks()
                },
                onError: { error in
                    print("Failed removed todos: \(error)")
                }
                
            )
            .disposed(by: disposeBag)
    }
}


struct TaskRow: View {
    @State private var isSelected: Bool = false
    @State var taskName: String
    var didRemoveTodo: (() -> Void)
    
    
    var body: some View {
        HStack {
            RadioButton(isSelected: isSelected) {
                isSelected.toggle()
            }
            .frame(width: 40, height: 40)
            Text(taskName)
                .strikethrough(isSelected, color: .black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                didRemoveTodo()
            }) {
                Image(systemName: "trash")
                    .frame(width: 40, height: 40)
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(20)
                    .padding(.trailing, 16)
            }
        }
        .padding()
        .contentShape(Rectangle())
        .background(Color.white)
        
    }
}

#Preview {
    HomeView()
}
