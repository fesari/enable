//
//  OnboardingViewPart2.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import SwiftUI

struct OnboardingViewPart2: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showImagePicker: Bool = false
    
    // MARK: PROPERTIES
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerID: String
    @Binding var provider: String
    
    // MARK: IMAGE PICKER
    @State var imageSelected: UIImage = UIImage(named: "logo.normal.transparent")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State var showError: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            TextField("Add your name here...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .foregroundColor(.black)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            // Show the image picker if the user has finished deciding their name.
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.greyColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            })
            .accentColor(Color.white)
            .opacity(displayName != "" ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 1.0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.redColor)
        .edgesIgnoringSafeArea(.all)
        // Create profile once sheet is dismissed with image selected.
        .sheet(isPresented: $showImagePicker, onDismiss: createProfile, content: {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        })
        // If error occurs, present an alert.
        .alert(isPresented: $showError) { () -> Alert in
            
            return Alert(title: Text("Error creating profile 😡"))
            
        }
    }
    
    // MARK: FUNCTIONS
    
    func createProfile() {
        print("CREATE PROFILE NOW")
        // create user data
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerID: providerID, provider: provider, profileImage: imageSelected) { (returnedUserID) in
            
            if let userID = returnedUserID {
                // SUCCESS
                print("Successfully created new user in database!")
                
                // log in user to firebase auth
                AuthService.instance.logInUserToApp(userID: userID) { (success) in
                    if success {
                        print("User logged in!")
                        // return to app
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        print("Error logging in")
                        self.showError.toggle()
                    }
                }
                
            } else {
                // ERROR
                print("Error creating user in Firebase")
                self.showError.toggle()
            }
            
        }
    }
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    
    @State static var testString: String = "Test"
    
    static var previews: some View {
        OnboardingViewPart2(displayName: $testString, email: $testString, providerID: $testString, provider: $testString)
    }
}
