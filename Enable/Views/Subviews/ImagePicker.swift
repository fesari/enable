//
//  ImagePicker.swift
//  Enable
//
//  Created by Max Sinclair on 3/1/22.
//

import Foundation
import SwiftUI

// The image picker struct has the function of presenting a menu to the user which allows them to take a photo using the camera, with editing, or choosing a photo from their photo library for various purposes. In order do this we have to use some UIKit functionality through ViewControllers.

struct ImagePicker: UIViewControllerRepresentable {
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @Binding var imageSelected: UIImage
    @Binding var sourceType: UIImagePickerController.SourceType
    
    // This function creates the view controller for the picker itself.
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true // Allows for selected images to be cropped before submission.
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) { }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(parent: self)
    }
    
    // We define this class ImagePickerCoordinate to ensure that the Image Picker conforms to a UIImagePickerController specifically.
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        
        // This function defines the actual process of passing an image back to the calling view once it has been selected
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                // select the image for our app
                parent.imageSelected = image
                print("--> imageSelected \(parent.imageSelected)")
                // dismiss the screen
                parent.presentationMode.wrappedValue.dismiss()  // using the environment variable presentationMode to dismiss the view.
            }
        }
        
        
    }
    
    
    
}
