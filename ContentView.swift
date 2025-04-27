//
//  ContentView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI

struct ContentView: View {
    @State var account: User = User.nilData
    @State var splashStopShowing = false
    @State var isLoggedIn = false
    @State var isLoadingChanges = false
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        Group {
            if !splashStopShowing {
                SplashScreen(endSplash: $splashStopShowing)
            } else if !isLoggedIn {
                LogInView(account: self.$account, isLoggedIn: self.$isLoggedIn)
            } else {
                ZStack {
                    TabsView(account: self.$account, isLoggedIn: self.$isLoggedIn, isLoadingChanges: self.$isLoadingChanges)
                        .onChange(of: scenePhase) { newValue in
                            UserManager().dbo.collection("users").document(account.id!).updateData(newValue == .inactive || newValue == .background ? ["availability": 0] : ["availability": 1])
                            
                            if newValue != .active {
                                splashStopShowing = false
                            }
                        }
                    
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
                    .opacity(isLoadingChanges ? 1 : 0)
                    .ignoresSafeArea()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
