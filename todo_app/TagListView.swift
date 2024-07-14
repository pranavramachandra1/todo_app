//
//  TagListView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 7/13/24.
//

import SwiftUI

struct TagListView: View {
    
    @EnvironmentObject var listManager: ListManager
    @EnvironmentObject var listLibrary: ListLibrary
    @Environment(\.dismiss) var dismiss
    var task: Task?
    
    // Form fields:
    @State private var tagName: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(listManager.tags) { tag in
                        TagSetView(tag: tag)
                    }
                }
                .listStyle(PlainListStyle())
                
                Form {
                    TextField("Tag name: ", text: $tagName)
                    Button("Add tag") {
                        listManager.addTag(tag: Tag(tagName: tagName))
                        tagName = ""
                    }
                }
                .textFieldStyle(.roundedBorder)
                .foregroundColor(Color.blue)
                .background(Color.white)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Tags: ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") {
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

#Preview {
    TagListView()
//        .environmentObject(ListManager())
//        .environmentObject(ListLibrary())
}
