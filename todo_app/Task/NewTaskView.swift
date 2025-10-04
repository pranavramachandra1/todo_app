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
    var task: TodoTask?
    
    // Form fields:
    @State private var taskName: String = ""
    @State private var tagName: String = ""
    @State private var selectedTags: Set<Tag> = []
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task name: ", text: $taskName)
                Section(header: Text("Select Tags")) {
                    ForEach(listManager.tags, id: \.id) { tag in
                        HStack {
                            Text(tag.tagName)
                            Spacer()
                            Image(systemName: selectedTags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }
                        }
                    }
                }
                Button("Add task") {
                    if !taskName.isEmpty {
                        let t: TodoTask = TodoTask(taskName: taskName)
                        listManager.addTask(task: t)
                        for tag in selectedTags {
                            listManager.toggleTag(tag: tag, task: t)
                        }
                    }
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
