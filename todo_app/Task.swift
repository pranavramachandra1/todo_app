//
//  Task.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/29/24.
//

import Foundation

class Task: ObservableObject, Identifiable, Codable {
    
    var id = UUID()
    @Published var taskName: String
    @Published var isComplete: Bool
    
    init(id: UUID = UUID(), taskName: String, isComplete: Bool = false) {
        self.id = id
        self.taskName = taskName
        self.isComplete = isComplete
    }
    
    enum CodingKeys: String, CodingKey {
            case id, taskName, isComplete
        }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        taskName = try container.decode(String.self, forKey: .taskName)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskName, forKey: .taskName)
        try container.encode(isComplete, forKey: .isComplete)
    }
    
}
