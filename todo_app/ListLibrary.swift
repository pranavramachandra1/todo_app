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
