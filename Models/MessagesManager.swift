//
//  MessagesManager.swift
//  EduChat
//
//  Created by Љубомир Мићић on 21.6.22..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessagesManager: ObservableObject {
    let dbo = Firestore.firestore()
    @Published private(set) var messages: [MessageModel] = []
    @Published private(set) var lastMessageId = ""
    
    init() {
        getMessages()
    }
    
    func getMessages() {
        dbo.collection("chat").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }

            self.messages = documents.compactMap { document -> MessageModel? in
                do {
                    return try document.data(as: MessageModel.self)
                } catch {
                    print("Error decoding document into message: \(error)")
                    return nil
                }
            }
            
            self.messages.sort {$0.timestamp < $1.timestamp}
            
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    func sendMessages(newMessage: MessageModel) {
        do {
            try dbo.collection("chat").document().setData(from: newMessage)
        } catch {
            print("Error while uploading message: \(error)")
        }
    }
}

