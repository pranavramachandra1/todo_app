//
//  ListManager.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/29/24.
//

import Foundation

class ListManager: ObservableObject {
    
    @Published var list: [Task] = []
    
    init() {
        loadTasks()
    }
    
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
