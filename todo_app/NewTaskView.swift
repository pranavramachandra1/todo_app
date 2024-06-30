//
//  NewTaskView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/29/24.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var listManager: ListManager
    @EnvironmentObject var listLibrary: ListLibrary
    @Environment(\.dismiss) var dismiss
    var task: Task?
    
    // Form fields:
    @State private var taskName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task name: ", text: $taskName)
                Button("Add task") {
                    listManager.addTask(task: Task(taskName: taskName))
                    dismiss()
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            .navigationTitle("New Task: ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let listLibrary = ListLibrary()
        let listManager = ListManager(listLibrary: listLibrary)
        
        NewTaskView()
            .environmentObject(listManager)
            .environmentObject(listLibrary)// Provide environment object for preview
    }
}
