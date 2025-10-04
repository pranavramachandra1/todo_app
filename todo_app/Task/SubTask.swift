//
//  SubTask.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 11/8/24.
//

import Foundation

class SubTask: ObservableObject, Identifiable, Codable {
    
    var id = UUID()
    @Published var subTaskName: String
    @Published var isComplete: Bool
    @Published var parentTask: UUID
    
    init(id: UUID = UUID(), subTaskName: String, isComplete: Bool = false, parentTask: UUID) {
        self.id = id
        self.subTaskName = subTaskName
        self.isComplete = isComplete
        self.parentTask = parentTask
    }
    
    static func == (lhs: SubTask, rhs: SubTask) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
            case id, subTaskName, isComplete, parentTask
        }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        subTaskName = try container.decode(String.self, forKey: .subTaskName)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        parentTask = try container.decode(UUID.self, forKey: .parentTask)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(subTaskName, forKey: .subTaskName)
        try container.encode(isComplete, forKey: .isComplete)
        try container.encode(parentTask, forKey: .parentTask)
    }
}
