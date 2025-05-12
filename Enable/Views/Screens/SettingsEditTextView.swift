//
//  SettingsEditTextView.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import SwiftUI

// This view is used for several settings options in settings view and implements variability to stop repetitive code.

struct SettingsEditTextView: View {
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingsEditTextOption: SettingsEditTextOption
    @Binding var profileText: String
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @State var showSuccessAlert: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            TextField(placeholder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .foregroundColor(.black)
            
            Button(action: {
                if textIsAppropriate() {
                    saveText()
                }
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.redColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.white)
            
            Spacer()
            
        }
        .padding()
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert, content: {
            return Alert(title: Text("Saved 🥶"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        })
        .frame(maxWidth: .infinity)
    }
    
    
    // MARK: FUNCTIONS
    
    func textIsAppropriate() -> Bool {
        // Check for text length
        
        if submissionText.count < 3 {
            return false
        }
        
        return true
    }
    
    func saveText() {
        
        guard let userID = currentUserID else { return }
        
        switch settingsEditTextOption {
        case .displayName:
            
            // Update the Ui on the profile
            self.profileText = submissionText
            
            // Update the userdefaults
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.displayName)
            
            // Update on all of the user's exercise and routines and messages
            DataService.instance.updateDisplayNameOnExercises(userID: userID, displayName: submissionText)
            
            // Update on user's profile in DB
            AuthService.instance.updateUserDisplayName(userID: userID, displayName: submissionText) { success in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }
            
            
        case .bio:
            // Update the Ui on the profile
            self.profileText = submissionText
            
            // Update the userdefaults
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
            
            // Update on user's profile in DB
            AuthService.instance.updateUserBio(userID: userID, bio: submissionText) { success in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }
            
        }
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        NavigationView {
            SettingsEditTextView(title: "Test Title", description: "This is a description", placeholder: "Placeholder", settingsEditTextOption: .displayName, profileText: $text)
        }
    }
}
