//
//  ChatMessage.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import Foundation
import FirebaseFirestoreSwift

struct MessageModel: Codable, Hashable {
    @DocumentID var id: String?
    var message: String, receiverId: String, senderId: String, timestamp: Date
}
