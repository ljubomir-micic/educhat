//
//  FilePickers.swift
//  EduChat
//
//  Created by Љубомир Мићић on 16.6.22..
//

import SwiftUI
import UIKit

struct FilePicker: UIViewControllerRepresentable {
    @Binding var shown: Bool
    @Binding var image: UIImage
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image1: $image, shown1: $shown)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FilePicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<FilePicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: UIImage
        @Binding var shown: Bool
        
        init(image1: Binding<UIImage>, shown1: Binding<Bool>) {
            _image = image1
            _shown = shown1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            shown.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiimages = lowerImageSize(info[.originalImage] as! UIImage)
            image = uiimages
            shown.toggle()
        }
        
        func lowerImageSize(_ image: UIImage) -> UIImage {
            // 150 * 200
            var newSize: CGSize = CGSize(width: 0, height: 0)
            
            if (image.size.width / 3 == image.size.height / 4) {
                newSize = CGSize(width: 150, height: 200)
            } else if (image.size.width / 4 == image.size.height / 3) {
                newSize = CGSize(width: 200, height: 150)
            } else {
                newSize = CGSize(width: 200, height: 200)
            }
            
            let rect = CGRect(origin: .zero, size: newSize)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
                
            return newImage!
        }
        
        func uiImg2Base64(img: UIImage) -> String {
            let imageData: NSData = img.pngData()! as NSData
            return imageData.base64EncodedString(options: .lineLength64Characters)
        }
    }
}
