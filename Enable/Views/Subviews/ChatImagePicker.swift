//
//  ChatImagePicker.swift
//  Enable
//
//  Created by Max Sinclair on 10/1/22.
//

import Foundation
import SwiftUI

// The original chat image picker struct is an adaptation of the original ImagePicker struct for chat messages specifically.

struct ChatImagePicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return ChatImagePicker.Coordinator(parent1: self)
    }
    
    
    @Binding var chatImagePicker: Bool
    @Binding var imgData: Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ChatImagePicker
        
        init(parent1: ChatImagePicker) {
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent.chatImagePicker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            parent.imgData = image.jpegData(compressionQuality: 0.5)!
            parent.chatImagePicker.toggle()
        }
    }
}
