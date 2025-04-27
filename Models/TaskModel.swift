//
//  TaskModel.swift
//  EduChat
//
//  Created by Љубомир Мићић on 23.6.22..
//

import Foundation
import FirebaseFirestoreSwift

struct TaskModel: Codable, Hashable {
    @DocumentID var id: String?
    var due: String?, status: Int, task: String
    
    mutating func ToggleisDone() {
        if status == 0 {
            status = 1
        } else {
            status = 0
        }
    }
}
