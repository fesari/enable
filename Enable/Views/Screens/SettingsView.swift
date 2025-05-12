//
//  SettingsView.swift
//  Enable
//
//  Created by Max Sinclair on 5/1/22.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: PROPERTIES
    @State var loading: Bool = false
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @Environment(\.presentationMode) var presentationMode
    @State var showSignOutError: Bool = false
    
    @Binding var userDisplayName: String
    @Binding var userBio: String
    @Binding var userProfilePicture: UIImage
    
    @State var presentWalkthrough: Bool = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Group {
                    
                    ScrollView(.vertical, showsIndicators: false, content: {
                        
                        
                        
                        
                        // MARK: SECTION 1: ENABLE
                        GroupBox(label: SettingsLabelView(labelText: "Enable", labelImage: "dot.radiowaves.left.and.right"), content: {
                            HStack(alignment: .center, spacing: 10) {
                                Image("logo.normal.transparent")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .cornerRadius(12)
                                
                                Text("Enable is the #1 app for organising your exercises and routines and communicating with your trainers and clinicians.")
                                    .font(.footnote)
                            }
                        })
                        .padding()
                        
                        // MARK: SECTION 2: PROFILE
                        GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                            
                            NavigationLink( // Change display name
                                destination: SettingsEditTextView(submissionText: userDisplayName, title: "Display Name", description: "You can edit your display name here, this will be seen by other users on your profile and exercises.", placeholder: "Your display name here...", settingsEditTextOption: .displayName, profileText: $userDisplayName),
                                label: {
                                    SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.redColor)
                                })
                            
                            NavigationLink( // Change or add bio
                                destination: SettingsEditTextView(submissionText: userBio, title: "Profile Bio", description: "Your bio is a great place to let users know a little bit about you, shown in your profile.", placeholder: "Your bio here...", settingsEditTextOption: .bio, profileText: $userBio),
                                label: {
                                    SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.redColor)
                                })
                            
                            NavigationLink( // Change profile picture (with preview)
                                destination: SettingsEditImageView(title: "Profile Picture", description: "Your profile picture will be shown on your profile, make it an image that is recognizable to others!", selectedImage: userProfilePicture, profileImage: $userProfilePicture),
                                label: {
                                    SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.redColor)
                                })
                            
                            Button(action: { // Sign out
                                self.loading = true
                                signOut()
                            }, label: {
                                SettingsRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color.MyTheme.redColor)
                            })
                            .alert(isPresented: $showSignOutError) {
                                return Alert(title: Text("Error signing out 😡"))
                            }
                            
                            
                        })
                        .padding()
                        
                        // MARK: SECTION 3: APPLICATION
                        
                        GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                            
                            Button(action: { // View manual
                                openCustomURL(urlString: "https://www.google.com")
                            }, label: {
                                SettingsRowView(leftIcon: "folder.fill", text: "User Manual", color: Color.MyTheme.greyColor)
                            })
                            
                            Button(action: { // View troubleshooting
                                openCustomURL(urlString: "https://www.bing.com")
                            }, label: {
                                SettingsRowView(leftIcon: "folder.fill", text: "Troubleshooting Guide", color: Color.MyTheme.greyColor)
                            })
                            
                            Button(action: { // Enable site
                                openCustomURL(urlString: "https://www.enableexercise.com.au/")
                            }, label: {
                                SettingsRowView(leftIcon: "globe", text: "Enable Website", color: Color.MyTheme.greyColor)
                            })
                            
                            Button(action: { // Walkthrough replay
                                presentWalkthrough.toggle()
                                
                            }, label: {
                                SettingsRowView(leftIcon: "questionmark", text: "Replay Walkthrough", color: Color.MyTheme.greyColor)
                            })
                            .fullScreenCover(isPresented: $presentWalkthrough,
                                             content: {
                                let plistManager = PlistManagerImpl()
                                let walkthroughContentManager = WalkthroughContentManagerImpl(manager: plistManager)
                                
                                WalkthroughScreenView(manager: walkthroughContentManager) {
                                    presentWalkthrough = false
                                }
                            })
                            
                            
                        })
                        .padding()
                        
                        // MARK: SECTION 3.5: DANGER ZONE/DELETE ACCOUNT
                        
                        GroupBox(label: SettingsLabelView(labelText: "Danger Zone", labelImage: "exclamationmark.triangle"), content: {
                            
                            Button {
                                deleteAccount()
                            } label: {
                                SettingsRowView(leftIcon: "trash", text: "Delete Account", color: Color.MyTheme.redColor)
                            }
                            
                            
                        })
                        .padding()
                        
                        // MARK: SECTION 4: SIGN OFF
                        GroupBox {
                            Text("Enable was made with love by Max Sinclair. \n Copyright 2022 ©")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .padding(.bottom, 80)
                        
                        
                        
                        
                        
                        
                        
                        
                    })
                    .navigationBarTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(leading:
                                            Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title)
                    })
                                                .accentColor(.primary)
                    )
                    
                }
                
                // If the user is logging out, a loading wheel is presented until the function returns
                
                if loading {
                    ZStack {
                        Color(.systemBackground)
                            .ignoresSafeArea()
                            .opacity(0.8)
                        
                        ProgressView()
                            .scaleEffect(3)
                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    }
                }
                
            }
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .accentColor(Color.MyTheme.redColor)
    }
    
    // MARK: FUNCTIONS
    
    func openCustomURL(urlString: String) { // For opening external websites
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut() {
        
        AuthService.instance.logOutUser { (success) in
            if success {
                print("Successfully logged out")
                
                // Dismiss settings view
                self.presentationMode.wrappedValue.dismiss()
                
            } else {
                print("Error logging out")
                self.showSignOutError.toggle()
            }
        }
    }
    
    func deleteAccount() {
        
        // Delete the user's exercise document data
        DataService.instance.deleteExerciseDocumentData(forUserID: currentUserID!)
        
        // Delete the user's user document data
        AuthService.instance.deleteUserDocumentData(forUserID: currentUserID!)
        
        // Delete the user's Storage exercise data
        ImageManager.instance.deleteExerciseImage(forUserID: currentUserID!)
        
        // Delete the user's Storage user data
        ImageManager.instance.deleteProfileImage(forUserID: currentUserID!)
        
        // Delete the user's account from FirebaseAuth
        AuthService.instance.deleteAccountFromAuth()
        
        // Clear UserDefaults for userID, bio and displayName and log out of the application
        signOut()
        
        
    }
    
    
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var testString: String = ""
    @State static var image: UIImage = UIImage(named: "dog1")!
    static var previews: some View {
        SettingsView(userDisplayName: $testString, userBio: $testString, userProfilePicture: $image)
    }
}
