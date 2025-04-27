//
//  EduChatApp.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI
import Firebase

@main
struct EduChatApp: App {
    let buttonColor: UIColor = #colorLiteral(red: 0.0, green: 0.6050000190734863, blue: 0.5575000047683716, alpha: 1.0)
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(buttonColor)
                    .ignoresSafeArea(edges: .top)
                    .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
                        Color(UIColor.systemBackground)
                    }
                
                ContentView()
            }
        }
    }
}

extension UIApplication {
    func keyboardDismission() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func string2Image(text: String) -> UIImage {
        let dataDecoded: NSData = NSData(base64Encoded: text, options: NSData.Base64DecodingOptions(rawValue: 0)) ?? NSData()
        let decodedimage: UIImage = UIImage(data: dataDecoded as Data) ?? #imageLiteral(resourceName: "User")
        return decodedimage
    }
}

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

extension Color {
    static let mint = Color(#colorLiteral(red: 0.0, green: 0.6050000190734863, blue: 0.5575000047683716, alpha: 1.0))
}
