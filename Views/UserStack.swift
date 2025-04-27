//
//  ChatStack.swift
//  EduChat
//
//  Created by Љубомир Мићић on 23.6.22..
//

import SwiftUI
import FirebaseFirestore

struct ChatStack: View {
    @Binding var id: String?
    @State var image: String
    var konverzacija: ConversationModel
    
    func dateEdit(_ datum: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MM. yyyy. HH:mm"
        let dateString = dateFormatter.string(from: datum)
        return dateString
    }
    
    var body: some View {
        HStack {
            Image(uiImage: self.image.imageFromBase64 ?? #imageLiteral(resourceName: "User"))
                .resizable()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .padding([.top, .bottom, .trailing], 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(konverzacija.senderId == self.id ? konverzacija.receiverName : konverzacija.senderName)
                        .font(.system(size: 17))
                        .bold()
                }
                
                Text(konverzacija.lastMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack {
                Text("\(dateEdit(konverzacija.timestamp))")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
                    .padding(.top, 5)
                
                Spacer()
            }
        }
        .padding(.horizontal, 2)
    }
}

struct AddChatStack: View {
    let account: User
    
    var body: some View {
        HStack {
            Image(uiImage: account.image.imageFromBase64 ?? #imageLiteral(resourceName: "User"))
                .resizable()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .padding([.top, .bottom, .trailing], 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(account.name)
                        .font(.system(size: 17))
                        .bold()
                }
                
                Text(account.email)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 2)
    }
}

struct ChatStack_Previews: PreviewProvider {
    @State static var id: String? = "lalala"
    @State static var image = User.sampleData.image
    @State static var konv = ConversationModel(lastMessage: "Eee", receiverId: "alalal", receiverImage: "", receiverName: "Hello", senderId: "lalala", senderImage: "", senderName: "Ljubomir", timestamp: Date())
    
    static var previews: some View {
        ChatStack(id: self.$id, image: self.image, konverzacija: self.konv)
    }
}
