//
//  ExerciseDetailView.swift
//  Enable
//
//  Created by Max Sinclair on 29/12/21.
//

import SwiftUI

// The exercise detail view contains the information shown when a user presses on a particular exercise within the LibraryView for more information. Therefore, it not only holds the information on a particular exercise but also of the user who has generated the exercise. However, currently the owner of an exercise can only be the ID of the logged in user. Shared exercises have not been implemented here.

struct ExerciseDetailView: View {
    
    // MARK: PROPERTIES
    @State var exercise: ExerciseModel // The specific exercise being selected
    @State var exerciseLargeImage: UIImage = UIImage(named: "logo")! // The image displayed at the top, the same as the image display in ExerciseView.
    @State var profileImage: UIImage = UIImage(named: "logo.default")! // If the user's profile image cannot be downloaded, we provide the logo as a default fallback.
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String? // Getting the userID current from AppStorage
    var body: some View {
        NavigationView {
            // MARK: IMAGE
            
            VStack {
                
                // If the user is signed in, we will simply pass the exerciseLargeImage variable which has been changed as a result of the getImages function on appear. However, if the user is logged out we provide optional images for default exercises.
                if let userID = currentUserID {
                    Image(uiImage: exerciseLargeImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(uiImage: exercise.optionalImage ?? UIImage(named: "logo.default")!)
                        .resizable()
                        .scaledToFit()
                }
                
                
                
                Spacer()
                
                // MARK: EXERCISE DETAILS
                
                RoundedRectangle(cornerRadius: 15)
                    .overlay(
                        VStack {
                            Text(exercise.exerciseTitle)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .scaledToFit()
                                .padding()
                            
                            // This link takes the user to the profile of the user who has created the exercise. If the user is the default user Enable for default exercises, a different call to ProfileView is used.
                            if let userID = currentUserID {
                                NavigationLink(
                                    destination:
                                        ProfileView(isMyProfile: false, profileDisplayName: exercise.username, profileUserID: exercise.userID, exercises: ExerciseArrayObject(userID: exercise.userID)),
                                    label: {
                                        HStack {
                                            Text(exercise.username)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                                .scaledToFit()
                                                .padding([.top,.leading, .bottom])
                                            
                                            
                                            
                                            Image(uiImage: profileImage)
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle())
                                                .font(.caption)
                                                .padding([.top, .bottom, .trailing])
                                            
                                            
                                            
                                            
                                        }
                                        .background(Color.MyTheme.beigeColor)
                                        .cornerRadius(12)
                                        
                                    })
                                    .accentColor(Color.MyTheme.redColor)
                            } else {
                                NavigationLink(
                                    destination:
                                        ProfileView(isMyProfile: false, profileDisplayName: "Enable", profileUserID: "", exercises: ExerciseArrayObject()),
                                    label: {
                                        HStack {
                                            Text(exercise.username)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                                .scaledToFit()
                                                .padding([.top,.leading, .bottom])
                                            
                                            
                                            
                                            Image(uiImage: profileImage)
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle())
                                                .font(.caption)
                                                .padding([.top, .bottom, .trailing])
                                            
                                            
                                            
                                            
                                        }
                                        .background(Color.MyTheme.beigeColor)
                                        .cornerRadius(12)
                                        
                                    })
                                    .accentColor(Color.MyTheme.redColor)
                            }
                            
                            
                            
                            
                            HStack {
                                Text(exercise.repsInfo)
                                    .foregroundColor(.white)
                                    .fontWeight(.light)
                                    .scaledToFit()
                                    .padding()
                                
                                Text(exercise.setsInfo)
                                    .foregroundColor(.white)
                                    .fontWeight(.light)
                                    .scaledToFit()
                                    .padding()
                            }
                            
                        }
                    )
                    .padding(15)
                    .padding(.horizontal)
                    .font(.headline)
                    .foregroundColor(Color.MyTheme.redColor)
                    .cornerRadius(8)
                    .shadow(color: Color.MyTheme.greyColor.opacity(0.3), radius: 10, x: 0, y: 10)
                
                Spacer()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .accentColor(Color.MyTheme.redColor)
        // When the view first appears, the getImages function is run to download the image from Firebase and set the profileImage variable to the image of the exercise being displayed.
        .onAppear {
            getImages()
        }
        
    }
    
    // MARK: FUNCTIONS
    
    func getImages() {
        
        // Get profile image
        ImageManager.instance.downloadProfileImage(userID: exercise.userID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
        
        // Get exercise image
        ImageManager.instance.downloadExerciseImage(exerciseID: exercise.exerciseID) { (returnedImage) in
            if let image = returnedImage {
                self.exerciseLargeImage = image
            }
        }
        
    }
    
}


