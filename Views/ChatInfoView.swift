//
//  ChatInfoView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 17.7.22..
//

import SwiftUI

struct ChatInfoView: View {
    @Binding var infoIsShown: Bool
    @Binding var account: User
    let buttonColor: UIColor = #colorLiteral(red: 0.0, green: 0.6050000190734863, blue: 0.5575000047683716, alpha: 1.0)
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isShowingShadow: false)
            
            ZStack {
                VStack {
                    Image(uiImage: account.image.imageFromBase64 ?? #imageLiteral(resourceName: "User"))
                            .resizable()
                            .scaledToFit()
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(account.name)
                                .font(.title)
                                .bold()
                            
                            Spacer()
                            
                            Text(account.availability == 1 ? "Online" : "Offline")
                                .foregroundColor(Color(buttonColor))
                                .font(.caption).bold()
                                .padding(.horizontal)
                                .padding(.vertical, 7)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                            
                        Text(account.email)
                    }
                    .padding([.top, .horizontal])
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                    .background(Color(buttonColor))
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .padding(.horizontal, 10)
                    .offset(y: -10)
                }
                .ignoresSafeArea(.all, edges: .bottom)
                
                VStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                infoIsShown = false
                            }) {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(Color(buttonColor))
                                    .overlay {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                    }
                            }
                            .padding()
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("Kontakt")
                                .font(.title2).bold()
                                .foregroundColor(Color(buttonColor))
                        }
                    }
                    .background(Material.ultraThin)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding()
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ChatInfoView_Previews: PreviewProvider {
    @State static var account: User = User.sampleData
    @State static var infoIsShown: Bool = true
    
    static var previews: some View {
        ChatInfoView(infoIsShown: self.$infoIsShown, account: self.$account)
    }
}
