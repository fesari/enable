//
//  ImagePickerViewStyle.swift
//  Enable
//
//  Created by Max Sinclair on 3/1/22.
//

import SwiftUI
import UIKit

// The purpose of this view is to style the image picker selector button presented to the user when creating exercises or routines, allowing them to see the image they will submit and choose between a number of options of media submission.

struct ImagePickerViewStyle: View {
    
    // MARK: PROPERTIES
    @State var showImagePicker: Bool = false
    @Binding var imageSelected: UIImage
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        
        // Defining the titling of the image picker button
        VStack(alignment: .leading, spacing: 10.0) {
            Image(systemName: "photo.fill")
                .font(.title)
            Text("Select.. (hold)")
                .font(.subheadline)
            
        }
        .foregroundColor(Color.white)
        .padding(30)
        .background(Color(#colorLiteral(red: 0.7294117647, green: 0.1568627451, blue: 0.1764705882, alpha: 1)).cornerRadius(30))
        .shadow(color: Color.MyTheme.greyColor.opacity(0.3), radius: 10, x: 0, y: 10)
        // The context menu here is opened when the user holds down, allowing a selection between two items: Camera and Photo Library.
        .contextMenu(menuItems: {
            
            Button(action: {
                // We set the source type based on the user's selection of which button is pressed, and then toggle a State property which triggers a sheet to be presented with the image picker view.
                sourceType = UIImagePickerController.SourceType.camera
                showImagePicker.toggle()
            }, label: {
                HStack {
                    Text("Camera")
                    Spacer()
                    Image(systemName: "camera.fill")
                }
                .padding(.horizontal)
            })
            
            
            Button(action: {
                // Similar to above, the source type is set to photo library.
                sourceType = UIImagePickerController.SourceType.photoLibrary
                showImagePicker.toggle()
            }, label: {
                HStack {
                    Text("Photo Library")
                    Spacer()
                    Image(systemName: "photo.fill.on.rectangle.fill")
                }
                .padding(.horizontal)
            })
            
            
        })
        // When the showImagePicker boolean state is toggled, a sheet is presented with the image picker view, which we track the output of using an imageSelected binding and tell what method to get the image from by providing an argument of sourcetype from the earlier button press.
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
                .accentColor(Color.MyTheme.redColor)
                .preferredColorScheme(.dark)
                
        })
        
        
        
        
    }
    
}
