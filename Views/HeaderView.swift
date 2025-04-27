//
//  HeaderView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 22.6.22..
//

import SwiftUI

struct HeaderView: View {
    @State var isShowingShadow: Bool
    
    var body: some View {
        ZStack {
            if isShowingShadow {
                Rectangle()
                    .fill(
                        Color.accentColor
                    )
                    .frame(height: 55)
                    .shadow(color: Color.black.opacity(0.35), radius: 3, x: 0, y: 4)
            } else {
                Rectangle()
                    .fill(
                        Color.accentColor
                    )
                    .frame(height: 55)
            }
            
            HStack {
                Text("EduChat")
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .bold()
                    .padding(.horizontal)
                    .shadow(radius: 3)
                
                Spacer()
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(isShowingShadow: false)
    }
}
