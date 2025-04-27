//
//  LogInView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LogInView: View {
    @Binding var account: User
    @Binding var isLoggedIn: Bool
    @State private var errorWrapper: ErrorWrapper?
    @State var registration: Bool = false
    @State var image: UIImage = #imageLiteral(resourceName: "User")
    @State var mail: String = ""
    @State var lozinka: String = ""
    @State var potvrdaLozinke: String = ""
    @State var ime: String = ""
    @State var odabiranjeSlike: Bool = false
    @State var tipNaloga: Bool = false
    @State var mailSkole: String = ""
    @State var isLogging: Bool = false
    
    enum logErrors: Error {
        case noNameEntered
        case noMailEntered
        case noPassEntered
        case passwordsNotMatching
        case passwordNotCorrect
        case accountDoesntExist
        
        var message: String {
            switch self {
                case .noNameEntered: return "Unesite ime"
                case .noMailEntered: return "Unesite mejl"
                case .noPassEntered: return "Unesite lozinku"
                case .passwordsNotMatching: return "Lozinke se ne podudaraju"
                case .passwordNotCorrect: return "Netacna lozinka"
                case .accountDoesntExist: return "Nalog ne postoji"
            }
        }
    }
    
    func errorMessage(errorDescription: String) -> String {
        return logErrors.noNameEntered.localizedDescription == errorDescription ? logErrors.noNameEntered.message :
        logErrors.noMailEntered.localizedDescription == errorDescription ? logErrors.noMailEntered.message :
        logErrors.noPassEntered.localizedDescription == errorDescription ? logErrors.noPassEntered.message :
        logErrors.passwordsNotMatching.localizedDescription == errorDescription ? logErrors.passwordsNotMatching.message :
        logErrors.passwordNotCorrect.localizedDescription == errorDescription ? logErrors.passwordNotCorrect.message :
        logErrors.accountDoesntExist.message
    }

    
    func Register() throws {
        if (self.ime.isEmpty) {
            throw logErrors.noNameEntered
        } else if(self.mail.isEmpty) {
            throw logErrors.noMailEntered
        } else if(self.lozinka.isEmpty) {
            throw logErrors.noPassEntered
        } else if(self.lozinka != self.potvrdaLozinke) {
            throw logErrors.passwordsNotMatching
        } else {
            // MARK: Da li nalog sa istim mejlom postoji?
            var nalogPostoji = false;
            Firestore.firestore().collection("users").addSnapshotListener { snapshotListener, error in
                for nalog in snapshotListener!.documents {
                    if nalog.data()["email"] as! String == self.mail {
                        nalogPostoji = true
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !nalogPostoji {
                    account = User(id: "\(UUID())", availability: 0, email: self.mail, image: self.image.base64 ?? #imageLiteral(resourceName: "User").base64!, name: self.ime, password: self.lozinka)
                    UserManager().AddUser(data: account)
                                            
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isLoggedIn = true
                    }
                }
            }
        }
    }
    
    func LogIn() throws {
        if (self.mail.isEmpty) {
            throw logErrors.noMailEntered
        } else if(self.lozinka.isEmpty) {
            throw logErrors.noPassEntered
        }
        
        self.account = User.nilData
        let dbo = Firestore.firestore()
        dbo.collection("users").whereField("email", isEqualTo: self.mail).whereField("password", isEqualTo: self.lozinka)
            .getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        
                        let d = User(id: document.documentID, availability: document.data()["availability"] as! Int, email: document.data()["email"] as! String, image: document.data()["image"] as! String, name: document.data()["name"] as! String, password: document.data()["password"] as! String)
                        
                        account = d
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isLoggedIn = true
                            addInFileThatYoureLoggedIn()
                        }
                    }
                }
        }
    }
    
    static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
                    .appendingPathComponent("eduprofile.data")
    }
    
    func addInFileThatYoureLoggedIn() {
        
    }
    
    func uiImg2Base64(img: UIImage) -> String {
        let imageData: NSData = img.pngData()! as NSData
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                if registration {
                    Button(action: {
                        odabiranjeSlike.toggle()
                    }) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    .foregroundColor(.gray)
                    .padding()
                    
                    TextField("Ime", text: self.$ime)
                        .frame(width: 240, height: 45)
                        .padding(.horizontal)
                        .foregroundColor(Color.accentColor)
                        .background(
                            Color.gray
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                        .submitLabel(.next)
                } else {
                    HStack {
                        Image("Icon_RC_500x500")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .padding()
                        
                        Text("EduChat")
                            .font(.title2)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing, 30)
                }
                
                TextField("Mail", text: self.$mail)
                    .frame(width: 240, height: 45)
                    .padding(.horizontal)
                    .foregroundColor(Color.accentColor)
                    .background(
                        Color.gray
                            .opacity(0.2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                    .textContentType(.username)
                    .submitLabel(.next)
                
                SecureField("Lozinka", text: self.$lozinka)
                    .frame(width: 240, height: 45)
                    .padding(.horizontal)
                    .foregroundColor(Color.accentColor)
                    .background(
                        Color.gray
                            .opacity(0.2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                    .textContentType(.password)
                    .submitLabel(.next)
                
                if registration {
                    SecureField("Potvrdi lozinku", text: self.$potvrdaLozinke)
                        .frame(width: 240, height: 45)
                        .padding(.horizontal)
                        .foregroundColor(Color.accentColor)
                        .background(
                            Color.gray
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                        .textContentType(.newPassword)
                        .submitLabel(.go)
                    /*
                    Toggle(isOn: $tipNaloga) {
                        Text("Profesorski nalog")
                    }
                    .frame(width: 260)
                     */
                    if (tipNaloga) {
                        TextField("Mail škole", text: self.$mailSkole)
                            .frame(width: 240, height: 45)
                            .padding(.horizontal)
                            .foregroundColor(Color.accentColor)
                            .background(
                                Color.gray
                                    .opacity(0.2)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                    }
                }
                
                if !isLogging {
                    Button(action: {
                        UIApplication.shared.keyboardDismission()
                        
                        do {
                            isLogging = true
                            
                            if registration {
                                try Register()
                            } else {
                                try LogIn()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                isLogging = false
                            }
                        } catch {
                            isLogging = false
                            
                            errorWrapper = ErrorWrapper(error: error, guidance: errorMessage(errorDescription: error.localizedDescription))
                        }
                    }) {
                        Text(registration ? "REGISTRUJ SE" : "ULOGUJ SE")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(Color.white)
                            .frame(width: 270, height: 50)
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                            .padding()
                    }
                    .sheet(item: $errorWrapper) { wrapper in
                        ErrorView(errorWrapper: wrapper)
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 38)
                }
            }
        
            VStack {
                Spacer()
                
                Button(action: {
                    registration.toggle()
                }) {
                    Text(!registration ? "Kreiraj nov nalog" : "Uloguj se")
                        .foregroundColor(Color("ContraBackgroundColor"))
                        .font(.system(size: 14, weight: .bold))
                        .padding()
                }
            }
        }
        .sheet(isPresented: self.$odabiranjeSlike) {
            FilePicker(shown: self.$odabiranjeSlike, image: self.$image)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    @State static var account = User(id: "", availability: 0, email: "", image: "", name: "", password: "")
    @State static var isLoggedIn = true
    
    static var previews: some View {
        LogInView(account: self.$account, isLoggedIn: self.$isLoggedIn)
    }
}
