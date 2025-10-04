//
//  TagSetView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 7/14/24.
//

import SwiftUI

struct TagSetView: View {
    @EnvironmentObject var listManager: ListManager
    @ObservedObject var tag: Tag
    @State var isPresentingTagSelectView: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                listManager.toggleActiveTag(tag: tag)
            }) {
                Image(systemName: tag.isActive ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(tag.isActive ? .blue : .black)
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
    TagSetView(tag: Tag(tagName: "Hello World"))
}
