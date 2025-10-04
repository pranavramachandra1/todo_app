//
//  Task.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/29/24.
//

import Foundation

class TodoTask: ObservableObject, Identifiable, Codable, Hashable {
    
    var id = UUID()
    @Published var taskName: String
    @Published var isComplete: Bool
    @Published var tags: [UUID]
    @Published var subTasks: [SubTask]
    
    init(id: UUID = UUID(), taskName: String, isComplete: Bool = false, tags: [UUID] = [], subTasks: [SubTask] = []) {
        self.id = id
        self.taskName = taskName
        self.isComplete = isComplete
        self.tags = tags
        self.subTasks = subTasks
    }
    
    static func == (lhs: TodoTask, rhs: TodoTask) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func turnToString() -> String {
        return " ID: \(self.id), taskName: \(self.taskName), isComplate: \(self.isComplete) "
    }
    
    func addTag(tag: Tag) {
        if !tags.contains(tag.id) {
            tags.append(tag.id)
        }
        
        if !tag.tasks.contains(self) {
            tag.tasks.append(self)
        }
    }
    
    func removeTag(tag: Tag) {
        if let index = tags.firstIndex(where: { $0 == tag.id }) {
            self.tags.remove(at: index)
        }
    }
    
    func removeAllTags() {
        self.tags.removeAll()
    }
    
    func hasTag(tagID: UUID) -> Bool {
        return self.tags.contains(tagID)
    }
    
    func addSubTask(subTask: SubTask) {
        self.subTasks.append(subTask)
    }
    
    func removedSubTask(subTask: SubTask) {
        
    }
    
    enum CodingKeys: String, CodingKey {
            case id, taskName, isComplete, tags, subTasks
        }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        taskName = try container.decode(String.self, forKey: .taskName)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        tags = try container.decode([UUID].self, forKey: .tags)
        subTasks = try container.decode([SubTask].self, forKey: .subTasks)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskName, forKey: .taskName)
        try container.encode(isComplete, forKey: .isComplete)
        try container.encode(tags, forKey: .tags)
        try container.encode(subTasks, forKey: .subTasks)
    }
    
}
