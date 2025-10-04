//
//  ListView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/29/24.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var listManager: ListManager
    @ObservedObject var task: TodoTask
    
    @State var isPresentingTagSelectView: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                listManager.toggleComplete(task: task)
            }) {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isComplete ? .green : .red)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Text(task.taskName)
                .strikethrough(task.isComplete, color: .black)
            
            Spacer()
            
            Button(action: {
                isPresentingTagSelectView = true
            }) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())
            .sheet(isPresented: $isPresentingTagSelectView) {
                TagSelectView(task: task)
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                listManager.deleteTask(task: task)
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: TodoTask(taskName: "Sample Task"))
    }
}
