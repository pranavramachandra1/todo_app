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
    @Published var tags: [Tag] = []
    @Published var viewableList: [Task] = []
    
    init(listLibrary: ListLibrary) {
        self.listLibrary = listLibrary
        loadTasks()
        
        let jsonURL = URL.documentsDirectory.appending(path: "Tags.json")
        if !FileManager().fileExists(atPath: jsonURL.path) {
            saveTags()
        }
        
        loadTags()
        
        viewableList = self.getCurrentTasks()
    }
    
    // Task Viewing Functionality:
    
    func getActiveTags() -> [Tag] {
        var activeTags: [Tag] = []
        
        for tag in tags {
            if tag.isActive {
                activeTags.append(tag)
            }
        }
        
        return activeTags
    }
    
    func getCurrentTasks() -> [Task] {
        let activeTags: [Tag] = self.getActiveTags()
        
        if activeTags.count == 0 {
            return self.list
        }
        
        var filteredTasks: Set<Task> = []
        
        for tag in activeTags {
            for task in tag.tasks {
                filteredTasks.insert(task)
            }
        }
        
        return Array(filteredTasks)
    }
    
    // Task/List Functionality
    
    func addTask(task: Task) {
        self.list.append(task)
        save()
        
        self.viewableList = self.list

    }
    
    func deleteTask(task: Task) {
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            self.list.remove(at: index)
            save()
        }
        
        self.viewableList = self.list
    }
    
    func toggleComplete(task: Task) {
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            self.list[index].isComplete.toggle()
            save()
        }
    }
    
    // Tag Functionality
    
    func addTag(tag: Tag) {
        self.tags.append(tag)
        save()
        saveTags()
    }
    
    func deleteTag(tag: Tag) {
        // Remove the tag from the tags list
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            self.tags.remove(at: index)
        }
        
        for task in self.list {
            if task.hasTag(tagID: tag.id) {
                task.removeTag(tag: tag)
            }
        }
    }
    
    func toggleActiveTag(tag: Tag) {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            self.tags[index].isActive.toggle()
            saveTags()
        }
        
        self.viewableList = self.getCurrentTasks()
    }
    
    func toggleTag(tag: Tag, task: Task) {
        if task.hasTag(tagID: tag.id) {
            task.removeTag(tag: tag)
        } else {
            task.addTag(tag: tag)
        }
        
        viewableList = self.getCurrentTasks()
        
        save()
        saveTags()
    }
    
    // List Operations:
    
    func clearList() {
        listLibrary.saveList(fileName: self.getFileName(), listManager: self)
        list = []
        save()
        
        viewableList = self.getCurrentTasks()
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
        
        viewableList = self.getCurrentTasks()
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
    
    func saveTags() {
        do {
            let jsonURL = URL.documentsDirectory.appending(path: "Tags.json")
            let listData = try JSONEncoder().encode(tags)
            try listData.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTags() {
        let jsonURL = URL.documentsDirectory.appending(path: "Tags.json")
        if FileManager().fileExists(atPath: jsonURL.path) {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                tags = try JSONDecoder().decode([Tag].self, from: jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
