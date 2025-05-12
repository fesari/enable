//
//  ProfileHeaderView.swift
//  Enable
//
//  Created by Max Sinclair on 5/1/22.
//

import SwiftUI

// The profile header view outlines the styling of the top half of ProfileView, containing the details of the current user logged in. This view is not applicable to logged out users, as they will automatically be prompted to log in, per ContentView.

struct ProfileHeaderView: View {
    
    // MARK: PROPERTIES
    // These properties are bindings to the settings view so they can be updated if the user decides to change either one of these.
    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    @Binding var profileBio: String
    
    var exerciseCount: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            
            // MARK: PROFILE PICTURE
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            
            // MARK: USERNAME
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // MARK: BIO
            if profileBio != "" {
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            
            
            // MARK: CONNECTIONS
            VStack(alignment: .center, spacing: 5, content: {
                Text("\(exerciseCount)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 20, height: 2, alignment: .center)
                
                // Grammatical data validation
                Text(exerciseCount == 1 ? "exercise" : "exercises")
                    .font(.callout)
                    .fontWeight(.medium)
                
            })
            
            
            
        })
        .frame(maxWidth: .infinity)
        .padding()
    }
    
struct ProfileHeaderView_Previews: PreviewProvider {
    @State static var name: String = "Joe"
    @State static var image: UIImage = UIImage(named: "logo.default")!
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image, profileBio: $name, exerciseCount: 1)
            .previewLayout(.sizeThatFits)
        }
    }
}
