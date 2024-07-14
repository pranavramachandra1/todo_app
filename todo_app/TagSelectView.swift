//
//  TagSelectView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 7/14/24.
//

import SwiftUI

struct TagSelectView: View {
    @EnvironmentObject var listLibrary: ListLibrary
    @EnvironmentObject var listManager: ListManager
    @State var listName: String = ""
    
    @ObservedObject var task: Task
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(listManager.tags) { tag in
                    TagActivateView(tag: tag, task: task)
                }
            }
            .navigationTitle("Select Tags for Task")
            
            Spacer()
        }
        
        Spacer()
    }
}

#Preview {
    TagSelectView(task: Task(taskName: "Hello world!"))
}
