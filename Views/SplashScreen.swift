//
//  SplashScreen.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI

struct SplashScreen: View {
    @Binding var endSplash: Bool
    let buttonColor: UIColor = #colorLiteral(red: 0.0, green: 0.6050000190734863, blue: 0.5575000047683716, alpha: 1.0)
    
    var body: some View {
        ZStack {
            Color(buttonColor)
            
            Image("Icon_RC_500x500")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            VStack {
                Spacer()
                
                HStack(alignment: .top, spacing: 0) {
                    Text("INFINITY")
                        .font(.system(size: 25, weight: .black))
                        .bold()
                    
                    Text("™")
                        .font(.caption)
                }
                .foregroundColor(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.84) {
                withAnimation(Animation.linear(duration: 0.35)) {
                    self.endSplash.toggle()
                }
            }
        }
        .opacity(endSplash ? 0 : 1)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    @State static var endSplash = false
    
    static var previews: some View {
        SplashScreen(endSplash: self.$endSplash)
    }
}
