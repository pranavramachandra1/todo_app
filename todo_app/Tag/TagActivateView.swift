//
//  TagActivateView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 7/14/24.
//

import SwiftUI

struct TagActivateView: View {
    @EnvironmentObject var listManager: ListManager
    @ObservedObject var tag: Tag
    @ObservedObject var task: TodoTask
    
    @State var isPresentingTagSelectView: Bool = false
    
    var body: some View {
        HStack {

            Button(action: {
                listManager.toggleTag(tag: tag, task: task)
            }) {
                Image(systemName: task.hasTag(tagID: tag.id) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.hasTag(tagID: tag.id) ? .blue : .black)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            
            Text(tag.tagName)
            
            Spacer()
        }
        .padding(.leading, 20)
        .swipeActions {
            Button(role: .destructive) {
                listManager.deleteTag(tag: tag)
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}

#Preview {
    TagActivateView(tag: Tag(tagName: "Personal"), task: TodoTask(taskName: "Hello World"))
}
