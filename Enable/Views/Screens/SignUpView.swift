//
//  SignUpView.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import SwiftUI

// View shown if the user is not logged in and tries to access the profile or connections view.

struct SignUpView: View {
    @State var showOnboarding: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            
            Spacer()
            Image("logo.normal.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            
            Text("You are not signed in 😥")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.MyTheme.redColor)
            
            Text("Click the button below to create an account and join the Enable Exercise app!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Button(action: {
                showOnboarding.toggle()
            }, label: {
                Text("Sign in/sign up".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.MyTheme.redColor)
                    .cornerRadius(12)
                    .shadow(radius: 12)
            })
            .accentColor(.white)
            Spacer()
            Spacer()
        })
        .padding(.all, 40)
        .background(Color.MyTheme.beigeColor)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardingView()
        })
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
