//
//  EditProfileDataView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 21.6.22..
//

import SwiftUI

struct EditProfDataView: View {
    @Binding var account: User
    @State var image: UIImage = UIImage()
    @State var odabiranjeFajla: Bool = false
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 200)
                .overlay(.regularMaterial)
            
            VStack {
                ZStack {
                    Image(uiImage: self.image)
                        .resizable()
                        .frame(width: 95, height: 95)
                        .overlay(Rectangle().fill(Color.black).opacity(0.3))
                        .clipShape(Circle())
                    
                    Text("Dodaj")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    Button(action: {
                        self.odabiranjeFajla = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .renderingMode(.template)
                            .frame(width: 95, height: 95)
                            .offset(x: 65 / 2, y: 65 / 2)
                    }
                    .sheet(isPresented: $odabiranjeFajla) {
                        FilePicker(shown: self.$odabiranjeFajla, image: self.$image)
                    }
                }
                .padding()
                
                VStack {
                    TextField("Ime", text: self.$account.name)
                        .frame(width: 240, height: 45)
                        .padding(.horizontal)
                        .background(
                            Color.gray
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                    
                    TextField("Mail", text: self.$account.email)
                        .frame(width: 240, height: 45)
                        .padding(.horizontal)
                        .background(
                            Color.gray
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                }
                .padding(.top, 1)
                
                Spacer()
            }
            .offset(y: -30)
        }
        .onAppear() {
            self.image = account.image.imageFromBase64 ?? #imageLiteral(resourceName: "User")
        }
        .onDisappear() {
            self.account.image = self.image.base64 ?? #imageLiteral(resourceName: "User").base64!
        }
    }
}

struct EditProfDataView_Previews: PreviewProvider {
    @State static var ljubomir = User(id: "1c1xdd12d312", availability: 1, email: "ljubomir.micic204@gmail.com", image: "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", name: "Ljubomir Micic", password: "lozinka")
    
    static var previews: some View {
        EditProfDataView(account: self.$ljubomir)
    }
}
