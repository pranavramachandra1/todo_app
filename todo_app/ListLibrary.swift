//
//  ListLibrary.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/30/24.
//

import Foundation

class ListLibrary: ObservableObject {
    
    @Published var fileNamesLibrary: [String] = []
    
    init() {
        let jsonURL = URL.documentsDirectory.appending(path: "ListLibrary.json")
        if !FileManager().fileExists(atPath: jsonURL.path) {
            save()
        }
        loadLibrary()
    }
    
    func getLastList() -> String? {
        if !fileNamesLibrary.isEmpty {
            return fileNamesLibrary.last
        }
        return ""
    }
    
    func addList(fileRoute: String) {
        fileNamesLibrary.append(fileRoute)
        save()
    }
    
    func getAllLists() -> [[Task]] {
        var lists: [[Task]] = []
        for fileName in fileNamesLibrary {
            lists.append(loadList(fileName: fileName))
        }
        return lists
    }
    
    func generateSuggestionPromot() -> String {
        var prompt = "In less than 100 words and based on the task data listed by the user, tell me the 1 type of task the user excels at, the 1 type of tasks the user struggles at, and a suggestion for the user to improve in the type of task that they struggle at. Here is the user data: "
        
        var all_tasks: [[Task]] = getAllLists()
        
        if all_tasks.isEmpty {
            return ""
        }
        
        for list in all_tasks {
            for task in list {
                prompt += task.turnToString()
            }
        }
        
        print(prompt)
        
        return prompt
    }
    
    func save() {
        do {
            let jsonURL = URL.documentsDirectory.appending(path: "ListLibrary.json")
            let listData = try JSONEncoder().encode(fileNamesLibrary)
            try listData.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadLibrary() {
        let jsonURL = URL.documentsDirectory.appending(path: "ListLibrary.json")
        if FileManager().fileExists(atPath: jsonURL.path) {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                fileNamesLibrary = try JSONDecoder().decode([String].self, from: jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveList(fileName: String, listManager: ListManager) {
        
        // Write file:
        do {
            let jsonURL = URL.documentsDirectory.appending(path: fileName)
            let listData = try JSONEncoder().encode(listManager.list)
            try listData.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
        
        // append to library and save:
        fileNamesLibrary.append(fileName)
        save()
        
    }
    
    func loadList(fileName: String) -> [Task] {
        let jsonURL = URL.documentsDirectory.appending(path: fileName)
        if FileManager().fileExists(atPath: jsonURL.path) {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let list = try JSONDecoder().decode([Task].self, from: jsonData)
                return list
            } catch {
                print(error.localizedDescription)
            }
        }
        print("File not found for \(fileName)")
        return []
    }
}
