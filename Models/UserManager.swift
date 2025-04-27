//
//  DataManager.swift
//  EduChat
//
//  Created by Љубомир Мићић on 15.6.22..
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager: ObservableObject {
    let dbo = Firestore.firestore()
    @Published private(set) var accounts: [User] = []
    
    init() {
        getUsers()
    }
    
    func getUsers() {
        dbo.collection("users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }

            self.accounts = documents.compactMap { document -> User? in
                do {
                    return try document.data(as: User.self)
                } catch {
                    print("Error decoding document into account: \(error)")
                    return nil
                }
            }
        }
    }
    
    func AddUser(data: User) {
        do {
            try dbo.collection("users").document(data.id!).setData(from: User(availability: data.availability, email: data.email, image: data.image, name: data.name, password: data.password));
        } catch {
            print("Error while trying to upload data!");
        }
    }
}
