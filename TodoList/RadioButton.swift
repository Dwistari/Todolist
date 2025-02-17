//
//  RadioButton.swift
//  TodoList
//
//  Created by Dwistari on 17/02/25.
//

import SwiftUI

struct RadioButton: View {
    
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            Image(systemName:  isSelected ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(isSelected ? .green : .gray)
        }
    }
}

