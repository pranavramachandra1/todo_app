//
//  TaskManager.swift
//  ToDo
//
//  Created by Pranav Ramachandra on 6/17/24.
//

import Foundation

class TaskManager: ObservableObject, Identifiable, Codable {
    
    var id = UUID()
    @Published var tasks: [Task]
    @Published var dateCreated: Date
    
    public init(id: UUID = UUID(), tasks: [Task] = [], dateCreated: Date = Date()) {
        self.id = id
        self.tasks = tasks
        self.dateCreated = dateCreated
    }
    
    // JSON Encoding:
    
    private enum CodingKeys: String, CodingKey {
            case id
            case tasks
            case dateCreated
        }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        tasks = try container.decode([Task].self, forKey: .tasks)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(dateCreated, forKey: .dateCreated)
    }
}
