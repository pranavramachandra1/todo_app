//
//  LibraryView.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/30/24.
//

import SwiftUI

struct LibraryView: View {
    
    @EnvironmentObject var listLibrary: ListLibrary
    @State var listName: String = ""
    
    var body: some View {
            NavigationStack {
                VStack {
                    Picker("Select previous ToDo list", selection: $listName) {
                        Text("Select Previous ToDo List").tag("")
                        
                        ForEach(0..<listLibrary.fileNamesLibrary.count, id: \.self) { index in
                            Text(formatFromFilename(fileName: listLibrary.fileNamesLibrary[index]))
                                .tag(listLibrary.fileNamesLibrary[index])
                        }
                    }
                    .navigationTitle("List Library:")
                    .padding(.top)
                    
                    Spacer()
                    
                    if (listName != "") {
                        let currList = listLibrary.loadList(fileName: listName)
                        
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(currList) { task in
                                    TaskView(task: task)
                                        .padding(.vertical, 5) // Add vertical padding between tasks
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    } else {
                        Spacer() // Add a Spacer to push the content upwards when no list is selected
                    }
                }
                .padding()
            }
    }
    
    func formatFromFilename(fileName: String) -> String {
        var selectName = "List of "
        
        let components = fileName.split(separator: "_")
        guard components.count >= 2 else { return "" }
        
        let dateComponent = String(components[1])
        guard dateComponent.count == 8 else { return "" }
        
        let year = String(dateComponent.prefix(4))
        let month = String(dateComponent.dropFirst(4).prefix(2))
        let day = String(dateComponent.dropFirst(6).prefix(2))
        
        selectName += month + "/" + day + "/" + year
        
        return selectName
    }
}

struct NewLibraryVIew_Previews: PreviewProvider {
    static var previews: some View {
        let listLibrary = ListLibrary()
        
        NewTaskView()
            .environmentObject(listLibrary)
    }
}
