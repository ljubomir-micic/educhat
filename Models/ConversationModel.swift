//
//  ConversationModel.swift
//  EduChat
//
//  Created by Љубомир Мићић on 23.6.22..
//

import Foundation

struct ConversationModel: Codable, Hashable {
    var lastMessage: String, receiverId: String, receiverImage: String, receiverName: String, senderId: String, senderImage: String, senderName: String, timestamp: Date
}
