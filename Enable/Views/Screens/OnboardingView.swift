//
//  OnboardingView.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import SwiftUI
import Firebase
//import GoogleSignIn
import FirebaseAuth

// This view presents the user with the option to either sign in via apple, google or return to the menu as a guest user.


struct OnboardingView: View {
    
    @State var loading: Bool = false
    
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingPart2: Bool = false
    @State var showError: Bool = false
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 10) {
                Image("logo.normal.transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .shadow(radius: 12)
                
                Text("Welcome to Enable!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.MyTheme.redColor)
                
                Text("Enable is the #1 app for organising your exercises and routines and communicating with your trainers and clinicians.")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
                    .padding()
                
                // MARK: SIGN IN WITH APPLE
                Button(action: {
                    SignInWithApple.instance.startSignInWithAppleFlow(view: self)
                }, label: {
                    SignInWithAppleButtonCustom()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                })
                
                // MARK: SIGN IN WITH GOOGLE
                Button(action: {
                    // handleGoogleLogin()
                }, label: {
                    HStack {
                        Image(systemName: "globe")
                        
                        Text("Sign in with Google")
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
                    .cornerRadius(6)
                    .font(.system(size: 23, weight: .medium, design: .default))
                })
                .accentColor(Color.white)
                
                // If the user chooses to return to the menu
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Continue as Guest".uppercased())
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding()
                })
                .accentColor(.black)
                
                
            }
            .padding(.all,20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.MyTheme.beigeColor)
            .edgesIgnoringSafeArea(.all)
            // If the user completes the sign in with either apple or google flow, they will continue to the second onboarding view, passing their details.
            .fullScreenCover(isPresented: $showOnboardingPart2, onDismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }, content: {
                OnboardingViewPart2(displayName: $displayName, email: $email, providerID: $providerID, provider: $provider)
            })
            .alert(isPresented: $showError) {
                return Alert(title: Text("Error signing in."))
            }
            
            // Loading bar for awaiting authentication.
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
    
    // MARK: FUNCTIONS
    
//    func handleGoogleLogin() {
//        // Google sign in...
//        
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()){
//            [self] user, err in
//            
//            if let error = err {
//                print("ERROR SIGNING IN TO GOOGLE")
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard
//                let authentication = user?.authentication,
//                let idToken = authentication.idToken
//            else {
//                return
//            }
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: authentication.accessToken)
//            
//            // Firebase Auth
//            self.loading = true
//            Auth.auth().signIn(with: credential) { result, err in
//                
//                if let error = err {
//                    print(error.localizedDescription)
//                    self.showError.toggle()
//                    return
//                }
//                
//                //displaying user name
//                
//                guard let user = result?.user else {
//                    return
//                }
//                
//                //set up profile
//                guard
//                    let fullName: String = user.displayName,
//                    let email: String = user.email
//                else {
//                    return
//                }
//                
//                // MARK: GOOGLE SIGN IN DATA COMPLETION
//                self.connectToFirebase(name: fullName, email: email, provider: "Google", credential: credential)
//                
//            }
//        }
//        
//    }
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        
        AuthService.instance.logInUserToFirebase(credential: credential) { (returnedProviderID, isError, isNewUser, returnedUserID) in
            
            if let newUser = isNewUser {
                
                if newUser {
                    // New user
                    if let providerID = returnedProviderID, !isError {
                        // SUCCESS
                        
                        // New user, continue to the onboarding part 2
                        self.displayName = name
                        self.email = email
                        self.provider = provider
                        self.providerID = providerID
                        self.showOnboardingPart2.toggle()
                        
                    } else {
                        // ERROR
                        print("Error getting provider ID from logging in user to Firebase.")
                        self.showError.toggle()
                    }
                } else {
                    // Existing user
                    
                    if let userID = returnedUserID {
                        // Success, log in to app
                        AuthService.instance.logInUserToApp(userID: userID) { (success) in
                            if success {
                                print("Successful log in existing user")
                                self.loading = false
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Error logging in existing user to app")
                                self.showError.toggle()
                            }
                        }
                    } else {
                        // ERROR
                        print("Error getting user ID from existing user to Firebase.")
                        self.showError.toggle()
                    }
                    
                }
                
            } else {
                // ERROR
                print("Error getting info from logging in user to Firebase.")
                self.showError.toggle()
            }
            
            
            
        }
        
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
