//
//  ListManager.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/29/24.
//

import Foundation

class ListManager: ObservableObject {
    
    var listLibrary: ListLibrary
    @Published var list: [Task] = []
    
    init(listLibrary: ListLibrary) {
        self.listLibrary = listLibrary
        loadTasks()
    }
    
    // Task/List Functionality
    
    func addTask(task: Task) {
        self.list.append(task)
        save()
    }
    
    func deleteTask(task: Task) {
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            self.list.remove(at: index)
            save()
        }
    }
    
    func toggleComplete(task: Task) {
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            self.list[index].isComplete.toggle()
            save()
        }
    }
    
    func clearList() {
        listLibrary.saveList(fileName: self.getFileName(), listManager: self)
        list = []
        save()
    }
    
    func rolloverList() {
        listLibrary.saveList(fileName: self.getFileName(), listManager: self)
        var newList: [Task] = []
        for task in list {
            if (!task.isComplete) {
                newList.append(task)
            }
        }
        list = newList
        save()
    }
    
    // JSON Naming and File Storage:
    
    func getFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        return "List_\(dateFormatter.string(from: Date())).json"
    }
    
    // Saving and encoding:
    
    func save() {
        do {
            let jsonURL = URL.documentsDirectory.appending(path: "List.json")
            let listData = try JSONEncoder().encode(list)
            try listData.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTasks() {
        let jsonURL = URL.documentsDirectory.appending(path: "List.json")
        if FileManager().fileExists(atPath: jsonURL.path) {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                list = try JSONDecoder().decode([Task].self, from: jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
