//
//  TaskRow.swift
//  TodoList
//
//  Created by Dwistari on 20/02/25.
//

import SwiftUI

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
