//
//  ConversationManager.swift
//  EduChat
//
//  Created by Љубомир Мићић on 23.6.22..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ConversationManager: ObservableObject {
    let dbo = Firestore.firestore()
    @Published public var conversations: [ConversationModel] = []
    
    init() {
        getConversations()
    }
    
    func getConversations() {
        dbo.collection("conversations").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }

            self.conversations = documents.compactMap { document -> ConversationModel? in
                do {
                    return try document.data(as: ConversationModel.self)
                } catch {
                    print("Error decoding document into account: \(error)")
                    return nil
                }
            }
            
            self.conversations.sort {$0.timestamp > $1.timestamp}
        }
    }
    
    func updateChat(_ convo: ConversationModel, _ message: MessageModel) {
        dbo.collection("conversations")
            .whereField("receiverId", isEqualTo: convo.receiverId)
            .whereField("senderId", isEqualTo: convo.senderId)
            .getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print(document.documentID); print(message.message)
                        self.dbo.collection("conversations").document(document.documentID).updateData(["lastMessage": message.message, "timestamp": message.timestamp])
                    }
                }
            }
    }
}
