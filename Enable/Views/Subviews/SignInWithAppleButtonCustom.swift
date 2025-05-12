//
//  SignInWithAppleButtonCustom.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import Foundation
import SwiftUI
import AuthenticationServices

// Apple's developers require iOS developers to create a custom button for sign in objects. This code has been implemented from the official Firebase website under Authentication for Apple devices. For an app to be submitted to the App Store it must have this requirement.

struct SignInWithAppleButtonCustom: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    
}
