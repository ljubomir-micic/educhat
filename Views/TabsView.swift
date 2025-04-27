//
//  TabsView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI

struct TabsView: View {
    @Binding var account: User
    @Binding var isLoggedIn: Bool
    @Binding var isLoadingChanges: Bool
    
    var body: some View {
        TabView() {
            ChatListView(account: self.$account, log: self.$isLoggedIn, isLoadingChanges: self.$isLoadingChanges)
                .tabItem {
                    Label("Čet", systemImage: "message.fill")
                }
            
            FilesListView()
                .tabItem {
                    Label("Fajlovi", systemImage: "folder.fill")
                }
            
            HomeworkSendingView()
                .tabItem {
                    Label("Domaći", systemImage: "doc.fill")
                }
            
            ToDoListView()
                .tabItem {
                    Label("Planer", systemImage: "square.and.pencil")
                }
            
            ProfileView(account: self.$account, log: self.$isLoggedIn, isLoadingChanges: self.$isLoadingChanges)
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    @State static var ljubomir = User.sampleData
    @State static var isLoggedIn: Bool = true
    @State static var isLoadingChanges: Bool = false
    
    static var previews: some View {
        TabsView(account: self.$ljubomir, isLoggedIn: self.$isLoggedIn, isLoadingChanges: self.$isLoadingChanges)
    }
}
