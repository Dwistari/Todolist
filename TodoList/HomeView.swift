//
//  Home.swift
//  TodoList
//
//  Created by Dwistari on 17/02/25.
//

import SwiftUI
import RxSwift
import CoreData

struct HomeView: View {
    @State private var input = ""
    @State private var tasks: [Todo] = []
    @State private var taskID: NSManagedObjectID?
    @State private var date = Date.now
    @State private var selectedDate = Date()
    @State private var showAlert = false

    let disposeBag = DisposeBag()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Input your task", text: $input)
                    .padding()
                    .border(Color.gray)
                    .padding(.leading, 10)
                Button(action: {
                    saveTasks()
                }) {
                    Image(systemName: "plus")
                        .frame(width: 40, height: 40)
                        .background(input.isEmpty ? .gray : .blue )
                        .foregroundColor(input.isEmpty ? .black : .white )
                        .cornerRadius(10)
                        .padding(.trailing, 16)
                        .disabled(input.isEmpty)
                }

            }
            
            DatePicker("Select Date", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .onChange(of: date) { newDate in
                    loadTasks()
                }
                .padding()
            
            Spacer()

            if tasks.isEmpty {
                Text("No tasks yet. Add a new task!")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                List {
                    ForEach(Array(tasks.enumerated()), id: \.element) { index, task in
                        TaskRow(isSelected: task.isFinished, taskName: task.name ?? "", didRemoveTodo: {
                            taskID = task.objectID
                            showAlert = true
                        }, didCheckedTodo: { isChecked in
                            updateTask(isFinished: isChecked, id: task.objectID)
                        })
                        
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
              Alert(
                  title: Text("Delete Task"),
                  message: Text("Are you sure you want to delete this task?"),
                  primaryButton: .destructive(Text("Delete")) {
                      if let id = taskID {
                          deleteTask(id: id)
                      }
                      print("Task deleted!")
                  },
                  secondaryButton: .cancel()
              )
          }
        
        .onAppear{
            loadTasks()
        }
        
    }
    
    
    private func saveTasks() {
        CoreDataManager.shared.saveContext(name: input, date: Date())
            .subscribe(
                onSuccess: {
                    input = ""
                    loadTasks()
                },
                onFailure: { error in
                    print("Failed to save todos: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func loadTasks() {
        CoreDataManager.shared.loadTodos(on: date)
            .subscribe(
                onSuccess: { todos in
                    tasks = todos
                },
                onFailure: { error in
                    print("Failed to load todos: \(error)")
                }
                
            )
            .disposed(by: disposeBag)
    }
    
    private func deleteTask(id: NSManagedObjectID) {
        CoreDataManager.shared.removeTodo(id: id)
            .subscribe(
                onCompleted: {
                    loadTasks()
                },
                onError: { error in
                    print("Failed removed todos: \(error)")
                }
                
            )
            .disposed(by: disposeBag)
    }
    
    private func updateTask(isFinished: Bool, id: NSManagedObjectID) {
        CoreDataManager.shared.updateTask(isFinished: isFinished, id: id)
            .subscribe(
                onSuccess: {
                    loadTasks()
                },
                onFailure: { error in
                    print("Failed removed todos: \(error)")
                }
                
            )
            .disposed(by: disposeBag)
    }
    
    
    private func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // Format tanggal
        return formatter.string(from: date)
    }
}


struct TaskRow: View {
    @State var isSelected: Bool
    @State var taskName: String
    var didRemoveTodo: (() -> Void)
    var didCheckedTodo: ((_ isChecked: Bool) -> Void)

    var body: some View {
        HStack {
            RadioButton(isSelected: isSelected) {
                isSelected.toggle()
                didCheckedTodo(isSelected)
            }
            .frame(width: 40, height: 40)
            Text(taskName)
                .strikethrough(isSelected, color: .black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
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
