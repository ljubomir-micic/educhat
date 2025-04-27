//
//  ProfileView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI

struct ProfileView: View {
    @Binding var account: User
    @Binding var log: Bool
    @Binding var isLoadingChanges: Bool
    @State var hasAddedImage = false
    @State var edit = false
    
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
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 200)
                .overlay(.regularMaterial)
            
            VStack {
                Image(uiImage: account.image.imageFromBase64 ?? #imageLiteral(resourceName: "User"))
                    .resizable()
                    .frame(width: 125, height: 125)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(lineWidth: 5).fill(Color(UIColor.systemBackground)))
                
                Text(self.account.name)
                    .font(.system(size: 26.5))
                    .bold()
                
                Text(self.account.email)
            }
            .offset(y: -30)
            
            Button(action: {
                edit = true
            }) {
                Text("Izmeni podatke")
                    .foregroundColor(Color.white)
                    .bold()
                    .frame(width: 270, height: 50)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
                    .padding(.horizontal)
            }
            .sheet(isPresented: $edit, onDismiss: {
                isLoadingChanges = true
                
                Task {
                    try await UserManager().dbo.collection("users").document(account.id!).updateData([
                        "image": account.image,
                        "name": account.name,
                        "email": account.email
                    ])
                    // Update in all conversations
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
            
            Button(action: {
                UserManager().dbo.collection("users").document(account.id!).updateData(["availability": 0])
                
                withAnimation {
                    account = User.nilData
                    self.log = false
                }
            }) {
                Text("Izloguj se")
                    .foregroundColor(Color.white)
                    .bold()
                    .frame(width: 270, height: 50)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
                    .padding([.horizontal, .top])
            }
            
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var account = User(id: "", availability: 0, email: "", image: "", name: "", password: "")
    @State static var log = true
    @State static var isLoadingChanges = false
    
    static var previews: some View {
        ProfileView(account: self.$account, log: self.$log, isLoadingChanges: self.$isLoadingChanges)
    }
}
