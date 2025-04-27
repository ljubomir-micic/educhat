//
//  AddChatView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 2.7.22..
//

import SwiftUI
import FirebaseFirestore

struct AddChatView: View {
    @StateObject var users = UserManager()
    @Binding var account: User
    @Binding var add: Bool
    @State var openNew: Bool = false
    @State var convoInfo: ConversationModel = ConversationModel(lastMessage: "", receiverId: "", receiverImage: "", receiverName: "", senderId: "", senderImage: "", senderName: "", timestamp: Date())
    @State var otherAcc: User = User.nilData
    let buttonColor: UIColor = #colorLiteral(red: 0.0, green: 0.6050000190734863, blue: 0.5575000047683716, alpha: 1.0)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    Color.accentColor
                )
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation {
                            add = false
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color(buttonColor))
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Izaberite korisnika")
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemBackground))
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                    
                    ZStack {
                        List(users.accounts, id: \.self) { user in
                            if user.email != account.email {
                                Button {
                                    convoInfo = ConversationModel(lastMessage: "", receiverId: user.id!, receiverImage: user.image, receiverName: user.name, senderId: self.account.id!, senderImage: self.account.image, senderName: self.account.name, timestamp: Date())
                                    self.otherAcc = User(id: user.id!, availability: user.availability, email: user.email, image: user.image, name: user.name, password: user.password)
                                    self.openNew = true
                                } label: {
                                    AddChatStack(account: user)
                                }
                                .fullScreenCover(isPresented: self.$openNew) {
                                    ChatView(account: self.$account, chatDidOpen: self.$openNew, conversationInfo: self.$convoInfo, isUploadingNewChat: true, otherAcc: self.$otherAcc)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                    }
                }
            }
        }
    }
}

struct AddChatView_Previews: PreviewProvider {
    @State static var add = true
    @State static var account = User.sampleData
    
    static var previews: some View {
        AddChatView(account: self.$account, add: self.$add)
    }
}
