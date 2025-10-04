//
//  SubTaskView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 11/8/24.
//

import SwiftUI

struct SubTaskView: View {
    @EnvironmentObject var listManager: ListManager
    @ObservedObject var task: TodoTask
    @ObservedObject var subTask: SubTask
    
    @State var isPresentingTagSelectView: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                listManager.toggleCompleteSubTask(task: task, subTask: subTask)
            }) {
                Image(systemName: subTask.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(subTask.isComplete ? .green : .red)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Text(subTask.subTaskName)
                .strikethrough(subTask.isComplete, color: .black)
            
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

struct SubTaskView_Previews: PreviewProvider {
    static var previews: some View {
        SubTaskView(task: TodoTask(taskName: "Sample Task"), subTask: SubTask(subTaskName: "SampleSubTask", parentTask: UUID()))
    }
}

