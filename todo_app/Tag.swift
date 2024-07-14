//
//  Tag.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 7/13/24.
//

import Foundation

class Tag: ObservableObject, Identifiable, Codable {
    
    var id = UUID()
    @Published var tagName: String
    @Published var isActive: Bool
    @Published var tasks: [Task]
    
    init(id: UUID = UUID(), tagName: String, isActive: Bool = false, tasks: [Task] = []) {
        self.id = id
        self.tagName = tagName
        self.isActive = isActive
        self.tasks = tasks
    }
    
    func turnToString() -> String {
        return " ID: \(self.id), taskName: \(self.tagName), isComplate: \(self.isActive) "
    }
    
    enum CodingKeys: String, CodingKey {
            case id, tagName, isActive, tasks
        }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        tagName = try container.decode(String.self, forKey: .tagName)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        tasks = try container.decode([Task].self, forKey: .tasks)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(tagName, forKey: .tagName)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(tasks, forKey: .tasks)
    }
    
}
