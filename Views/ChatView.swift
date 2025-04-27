//
//  ChatView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 27.6.22..
//

import SwiftUI

struct ChatView: View {
    @Binding var account: User
    @Binding var chatDidOpen: Bool
    @Binding var conversationInfo: ConversationModel
    @StateObject var chat = MessagesManager()
    @State var tekstualnaPoruka: String = ""
    let buttonColor: UIColor = #colorLiteral(red: 0.0, green: 0.6050000190734863, blue: 0.5575000047683716, alpha: 1.0)
    @State var isUploadingNewChat: Bool
    @State var infoDidOpen: Bool = false
    @Binding var otherAcc: User
    
    func dateFormat(datum: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MM. yyyy - HH:mm"
        return dateFormatter.string(from: datum)
    }
    
    func SendMessage() {
        let newMessage = MessageModel(message: tekstualnaPoruka, receiverId: otherAcc.id!, senderId: account.id!, timestamp: Date())
        
        MessagesManager().sendMessages(newMessage: newMessage)
        ConversationManager().updateChat(conversationInfo, newMessage)
    }
    
    func convoAccountId(_ id1: String, _ id2: String) -> String {
        return id1 == account.id ? id2 : id1
    }
    
    func preventingConversationDuplicates(_ addNew: Bool) -> Bool {
        if addNew == true {
            var messageCount = 0

            for message in self.chat.messages {
                if ((message.receiverId == account.id && message.senderId == otherAcc.id) || (message.senderId == account.id && message.receiverId == otherAcc.id)) {
                    messageCount += 1
                }
            }

            if(messageCount > 0) {
                return false
            }
        }
        
        return addNew
    }
    
    @ViewBuilder
    func MessageStack(_ poruka: MessageModel) -> some View {
        HStack {
            if (poruka.receiverId == account.id && poruka.senderId == otherAcc.id) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack (alignment: .bottom) {
                        Image(uiImage: self.otherAcc.image.imageFromBase64 ?? #imageLiteral(resourceName: "User"))
                            .resizable()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .padding(.trailing, 5)
                        
                        MessageBubble(poruka)
                    }
                    .padding(.horizontal, 15)
                    
                    Text("\(dateFormat(datum: poruka.timestamp))")
                        .font(.caption2)
                        .foregroundColor(.gray).opacity(0.5)
                        .padding(.leading, 60)
                }

                Spacer(minLength: 45)
            } else if (poruka.senderId == account.id && poruka.receiverId == otherAcc.id) {
                Spacer(minLength: 45)

                VStack(alignment: .trailing, spacing: 2) {
                    MessageBubble(poruka)
                    
                    Text("\(dateFormat(datum: poruka.timestamp))")
                        .font(.caption2)
                        .foregroundColor(.gray).opacity(0.5)
                }
                .padding(.horizontal, 15)
            }
        }
    }
    
    @ViewBuilder
    func MessageBubble(_ poruka: MessageModel) -> some View {
        Text(poruka.message)
            .foregroundColor(.white)
            .font(.system(size: 16))
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(poruka.receiverId == account.id ? Color(buttonColor) : Color.accentColor)
            .cornerRadius(20, corners: [.topLeft, .topRight, poruka.receiverId == account.id ? .bottomRight : .bottomLeft])
            .multilineTextAlignment(poruka.receiverId == account.id ? .leading : .trailing)
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.setValue(poruka.message, forPasteboardType: "public.plain-text")
                }) {
                    Label("Kopiraj", systemImage: "doc.on.doc")
                }
                
                /*
                Button(role: .destructive, action: {
                    var deleteIndex = 0
                    
                    for i in 0 ..< messages.count {
                        if messages[i].id == poruka.id {
                            deleteIndex = i
                        }
                    }
                    
                    withAnimation(.easeInOut) {
                        messages.remove(at: deleteIndex)
                        deleteIndex = 0
                    }
                }) {
                    Label("Obriši za mene", systemImage: "trash")
                }*/
                
                Divider()
                
                Button(role: .cancel, action: {}) {
                    Label("Odustani", systemImage: "x.circle")
                }
            }
    }
    
    func Convos() -> ConversationModel {
        for convo in ConversationManager().conversations {
            if (convo.receiverId == account.id && convo.senderId == otherAcc.id) || (convo.senderId == account.id && convo.receiverId == otherAcc.id) {
                return convo
            }
        }
        return conversationInfo
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(
                            Color.accentColor
                        )
                        .ignoresSafeArea()
                
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {
                                chatDidOpen = false
                            }) {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(buttonColor))
                                    .overlay {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                    }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center) {
                                Text("\(otherAcc.name)")
                                    .bold()
                                    .foregroundColor(.white)
                                
                                if otherAcc.availability == 1 {
                                    Text("Online")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.infoDidOpen = true
                            }) {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(buttonColor))
                                    .overlay {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.white)
                                    }
                            }
                            .fullScreenCover(isPresented: self.$infoDidOpen) {
                                ChatInfoView(infoIsShown: self.$infoDidOpen, account: self.$otherAcc)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemBackground))
                            
                            ScrollViewReader { proxy in
                                ScrollView {
                                    Spacer(minLength: 15)
                                    
                                    ForEach(chat.messages, id: \.id) { poruka in
                                        VStack(spacing: 0) {
                                            MessageStack(poruka)
                                                .id(poruka.id)
                                                .padding(.bottom, (poruka.receiverId == account.id && poruka.senderId == otherAcc.id) || (poruka.senderId == account.id && poruka.receiverId == otherAcc.id) ? 5 : 0)
                                        }
                                    }
                                    
                                    Spacer(minLength: 15)
                                }
                                .onChange(of: chat.lastMessageId) { id in
                                    withAnimation(.spring()) {
                                        proxy.scrollTo(id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                        
                        HStack {
                            TextField("Unesite poruku...", text: $tekstualnaPoruka)
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 9)
                                .padding(.horizontal, (9 + 5))
                                .background(Color(buttonColor))
                                .clipShape(Capsule())
                                .foregroundColor(Color.white)
                                .padding([.vertical, .leading])
                            
                            Button(action: {
                                isUploadingNewChat = preventingConversationDuplicates(isUploadingNewChat)
                                
                                if isUploadingNewChat {
                                    do {
                                        try ConversationManager().dbo.collection("conversations").document().setData(from: conversationInfo)
                                    } catch {
                                        print("err")
                                    }
                                } else {
                                    self.conversationInfo = Convos()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    SendMessage()
                                    tekstualnaPoruka = ""
                                    isUploadingNewChat = false
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color.white)
                                    
                                    Image(systemName: "paperplane.circle.fill")
                                        .resizable()
                                        .rotationEffect(Angle(degrees: 45.0))
                                        .foregroundColor(Color(buttonColor))
                                }
                                .frame(width: 40, height: 40)
                            }
                            .disabled(tekstualnaPoruka.isEmpty)
                            .padding(.trailing)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .padding(.top, 55)
            
            HeaderView(isShowingShadow: true)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    @State static var ljubomir = User.sampleData
    @State static var chatDidOpen = true
    @State static var conversationInfo = ConversationModel(lastMessage: "ee", receiverId: User.sampleData.id!, receiverImage: User.sampleData.image, receiverName: User.sampleData.name, senderId: "", senderImage: "", senderName: "Bobana", timestamp: Date())
    @State static var user2 = User.sampleData
    
    static var previews: some View {
        ChatView(account: self.$ljubomir, chatDidOpen: self.$chatDidOpen, conversationInfo: self.$conversationInfo, isUploadingNewChat: false, otherAcc: self.$user2)
    }
}
