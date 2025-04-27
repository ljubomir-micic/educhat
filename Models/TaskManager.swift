//
//  TaskManager.swift
//  EduChat
//
//  Created by Љубомир Мићић on 23.6.22..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TaskManager: ObservableObject {
    let dbo = Firestore.firestore()
    @Published private(set) var tasks: [TaskModel] = []
    
    init() {
        getTasks()
    }
    
    func getTasks() {
        dbo.collection("tasks").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }

            self.tasks = documents.compactMap { document -> TaskModel? in
                do {
                    return try document.data(as: TaskModel.self)
                } catch {
                    print("Error decoding document into account: \(error)")
                    return nil
                }
            }
        }
    }
    
    func uploadTasks(task: TaskModel) {
        do {
            try dbo.collection("tasks").document().setData(from: task)
        } catch {
            print("Error while uploading message: \(error)")
        }
    }
    
    func updateTask(tasks: [TaskModel]) {
        for task in tasks {
            self.dbo.collection("tasks").document(task.id!).updateData(["status": task.status])
        }
    }
}
