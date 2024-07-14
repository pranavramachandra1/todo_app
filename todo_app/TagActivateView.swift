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
    @ObservedObject var task: Task
    
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
    TagActivateView(tag: Tag(tagName: "Personal"), task: Task(taskName: "Hello World"))
}
