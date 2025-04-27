//
//  ChatListView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI

struct ChatListView: View {
    @Binding var account: User
    @Binding var log: Bool
    @Binding var isLoadingChanges: Bool
    @StateObject var conversationManager: ConversationManager = ConversationManager()
    @State var addConv: Bool = false
    @State var chatDidOpen: Bool = false
    @State var edit: Bool = false
    @State var otherAcc: User = User.nilData
    let buttonColor: UIColor = #colorLiteral(red: 0.0, green: 0.6050000190734863, blue: 0.5575000047683716, alpha: 1.0)
    
    @ViewBuilder
    func imageIcon(_ img: Image) -> some View {
        img
            .resizable()
            .foregroundColor(.white)
            .background(Color(buttonColor))
            .scaledToFill()
    }
    
    fileprivate func senderInfoUpdate() {
        ConversationManager().dbo.collection("conversations").whereField("senderId", isEqualTo: self.account.id!).getDocuments() { snap, error in
            if let error = error {
                print("\(error)")
            } else {
                for document in snap!.documents {
                    ConversationManager().dbo.collection("conversations").document(document.documentID).updateData(["senderImage": self.account.image, "senderName": self.account.name])
                }
            }
        }
    }
    
    fileprivate func receiverInfoUpdate() {
        ConversationManager().dbo.collection("conversations").whereField("receiverId", isEqualTo: self.account.id!).getDocuments() { snap, error in
            if let error = error {
                print("\(error)")
            } else {
                for document in snap!.documents {
                    ConversationManager().dbo.collection("conversations").document(document.documentID).updateData(["receiverImage": self.account.image, "receiverName": self.account.name])
                }
            }
        }
    }
    
    fileprivate func updateProfile() async {
        try? await UserManager().dbo.collection("users").document(account.id!).updateData([
            "email": account.email,
            "image": account.image,
            "name": account.name
        ])
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(
                            Color.accentColor
                        )
                    
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {
                                edit.toggle()
                            }) {
                                imageIcon(Image(uiImage: account.image.imageFromBase64 ?? #imageLiteral(resourceName: "User")))
                            }
                            .frame(width: 35, height: 35)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                            )
                            .sheet(isPresented: $edit, onDismiss: {
                                isLoadingChanges = true
                                
                                Task {
                                    await updateProfile()
                                    senderInfoUpdate()
                                    receiverInfoUpdate()
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    isLoadingChanges = false
                                }
                            }) {
                                VStack(spacing: 0) {
                                    HStack {
                                        Spacer()
                                        
                                        Button(action: {
                                            edit = false
                                        }) {
                                            Text("Gotovo")
                                                .foregroundColor(.white)
                                        }
                                        .buttonStyle(.bordered)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 9)
                                    }
                                    .background(
                                        Color.accentColor
                                    )
                                    
                                    EditProfDataView(account: self.$account)
                                }
                            }
                            
                            Spacer()
                            
                            Text(account.name)
                                .bold()
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                UserManager().dbo.collection("users").document(account.id!).updateData(["availability": 0])
                                
                                withAnimation {
                                    account = User.nilData
                                    log = false
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(Color(buttonColor))
                                    
                                    Image(systemName: "power")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemBackground))
                                .cornerRadius(20, corners: [.topLeft, .topRight])
                            
                            ZStack {
                                if (conversationManager.conversations.contains(where: { ($0.receiverId == self.account.id) || ($0.senderId == self.account.id) })) {
                                    List {
                                        ForEach(self.$conversationManager.conversations, id: \.self) { $konverzacija in
                                            if(konverzacija.senderId == self.account.id || konverzacija.receiverId == self.account.id) {
                                                Button(action: {
                                                    UserManager().dbo.collection("users").document(konverzacija.receiverId == self.account.id ? konverzacija.senderId : konverzacija.receiverId).addSnapshotListener { documentSnapshot, err in
                                                        guard let documents = documentSnapshot?.data() else {
                                                            print("Error fetching documents: \(String(describing: err))")
                                                            return
                                                        }

                                                        self.otherAcc = User(id: konverzacija.receiverId == self.account.id ? konverzacija.senderId : konverzacija.receiverId, availability: documents["availability"] as! Int, email: documents["email"] as! String, image: documents["image"] as! String, name: documents["name"] as! String, password: documents["password"] as! String)
                                                    }
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        chatDidOpen = true
                                                    }
                                                }) {
                                                    ChatStack(id: self.$account.id, image: konverzacija.receiverId == self.account.id ? konverzacija.senderImage : konverzacija.receiverImage, konverzacija: konverzacija)
                                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                                }
                                                .fullScreenCover(isPresented: self.$chatDidOpen) {
                                                    ChatView(account: self.$account, chatDidOpen: $chatDidOpen, conversationInfo: $konverzacija, isUploadingNewChat: false, otherAcc: self.$otherAcc)
                                                }
                                            }
                                        }
                                    }
                                    .listStyle(PlainListStyle())
                                    .cornerRadius(20, corners: [.topLeft, .topRight])
                                } else {
                                    VStack {
                                        Image("Chat_Blank")
                                            .resizable()
                                        //.scaledToFit()
                                            .frame(width: 280, height: 280)
                                        
                                        Text("Započnite ćaskanje klikom \nna \"+\"")
                                            .font(.system(size: 18).italic())
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.center)
                                            .padding(.top, 20)
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred() // haptic feedback
                                    addConv = true
                                }) {
                                    ZStack {
                                        Circle()
                                            .frame(width: 50, height: 50)
                                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                                        Image(systemName: "plus")
                                            .font(.system(size: 25).bold())
                                            .foregroundColor(Color.white)
                                    }
                                }
                                .sheet(isPresented: $addConv) {
                                    AddChatView(account: self.$account, add: self.$addConv)
                                }
                            }
                            .padding(20)
                        }
                    }
                }
            }
            .padding(.top, 55)
            
            HeaderView(isShowingShadow: true)
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    @State static var ljubomir = User.sampleData
    @State static var log = true
    @State static var isLoadingChanges = false
    
    static var previews: some View {
        ChatListView(account: self.$ljubomir, log: self.$log, isLoadingChanges: self.$isLoadingChanges)
    }
}
