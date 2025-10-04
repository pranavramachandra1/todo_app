//
//  ListManager.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/29/24.
//

import Foundation

class ListManager: ObservableObject {
    
    var listLibrary: ListLibrary
    @Published var list: [TodoTask] = []
    @Published var tags: [Tag] = []
    @Published var viewableList: [TodoTask] = []
    
    // New Data Structures:
    @Published var taskMap: [UUID: TodoTask] = [:]
    @Published var tagMap: [UUID: Tag] = [:]
    
    private var taskToTags: [UUID: Set<UUID>] = [:]
    private var tagToTasks: [UUID: Set<UUID>] = [:]
    
    init(listLibrary: ListLibrary) {
        self.listLibrary = listLibrary
        loadTasks()
        
        let jsonURL = URL.documentsDirectory.appending(path: "Tags.json")
        if !FileManager().fileExists(atPath: jsonURL.path) {
            saveTags()
        }
        
        loadTags()        
        loadTaskMap()
        loadTaskMap()
        
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
    
    func getCurrentTasks() -> [TodoTask] {
        let activeTags: [Tag] = self.getActiveTags()
        
        if activeTags.count == 0 {
            return self.list
        }
        
        var filteredTasks: Set<TodoTask> = []
        
        for tag in activeTags {
            for task in tag.tasks {
                if self.list.contains(task) {
                    filteredTasks.insert(task)
                }
            }
        }
        
        return Array(filteredTasks)
    }
    
    // Task/List Functionality
    
    func addTask(task: TodoTask) {
        self.list.append(task)
        self.taskMap[task.id] = task
        save()
        saveTaskMap()
        
        self.viewableList = self.list

    }
    
    func deleteTask(task: TodoTask) {
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            self.list.remove(at: index)
            save()
        }
        
        self.taskMap.removeValue(forKey: task.id)
        
        self.viewableList = self.list
    }
    
    func toggleComplete(task: TodoTask) {
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            self.list[index].isComplete.toggle()
            save()
        }
    }
    
    func toggleCompleteSubTask(task: TodoTask, subTask: SubTask) {
        if let index = task.subTasks.firstIndex(where: { $0.id == subTask.id }) {
            task.subTasks[index].isComplete.toggle()
            save()
        }
    }
    
    func addSubTask(task: TodoTask, subTask: SubTask) {
        task.addSubTask(subTask: subTask)
        
        save()
        self.viewableList = self.list
    }
    
    func removeSubTask(task: TodoTask, subTask: SubTask) {
        if let index = task.subTasks.firstIndex(where: { $0.id == subTask.id }) {
            task.subTasks.remove(at: index)
            save()
        }
        
        self.viewableList = self.list
    }
    // Tag Functionality
    
    func addTag(tag: Tag) {
        self.tags.append(tag)
        
        self.tagMap[tag.id] = tag
        
        save()
        saveTags()
        saveTagMap()
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
        
        self.tagMap.removeValue(forKey: tag.id)
        
        saveTagMap()
    }
    
    func toggleActiveTag(tag: Tag) {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            self.tags[index].isActive.toggle()
            saveTags()
        }
        
        self.viewableList = self.getCurrentTasks()
    }
    
    func toggleTag(tag: Tag, task: TodoTask) {
        
        print("----")
                
        if task.hasTag(tagID: tag.id) {
            task.removeTag(tag: tag)
            tag.untag(untagged_tasks: [task])
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
        
        // Remove all tasks from each tag
        for tag in self.tags {
            tag.untagAll()
        }
        
        list = []
        save()
        saveTags()
        
        viewableList = self.getCurrentTasks()
    }
    
    func rolloverList() {
        listLibrary.saveList(fileName: self.getFileName(), listManager: self)
        var newList: [TodoTask] = []
        var untaggedTasks: [TodoTask] = []
        for task in list {
            if (!task.isComplete) {
                newList.append(task)
            } else {
                untaggedTasks.append(task)
            }
        }
        
        for tag in self.tags {
            tag.untag(untagged_tasks: untaggedTasks)
        }
        
        list = newList
        save()
        saveTags()
        
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
                list = try JSONDecoder().decode([TodoTask].self, from: jsonData)
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
    
    func saveTaskMap() {
        do {
            let jsonURL = URL.documentsDirectory.appending(path: "TaskMap.json")
            let listData = try JSONEncoder().encode(Array(taskMap.values))
            try listData.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTaskMap() {
        let jsonURL = URL.documentsDirectory.appending(path: "TaskMap.json")
        if FileManager().fileExists(atPath: jsonURL.path) {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let tasks = try JSONDecoder().decode([TodoTask].self, from: jsonData)
                tasks.forEach { taskMap[$0.id] = $0 }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveTagMap() {
        do {
            let jsonURL = URL.documentsDirectory.appending(path: "TagMap.json")
            let listData = try JSONEncoder().encode(Array(tagMap.values))
            try listData.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTagMap() {
        let jsonURL = URL.documentsDirectory.appending(path: "TagMap.json")
        if FileManager().fileExists(atPath: jsonURL.path) {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let tasks = try JSONDecoder().decode([Tag].self, from: jsonData)
                tasks.forEach { tagMap[$0.id] = $0 }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
