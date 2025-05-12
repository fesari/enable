//
//  ProfileView.swift
//  Enable
//
//  Created by Max Sinclair on 5/1/22.
//

import SwiftUI

// This view presents the user with an overview of their profile information (name, bio, exercises and routines and an image as well as settings)

struct ProfileView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    // Setting grid display mode
    var columns = Array(repeating: GridItem(.flexible()), count: 1)
    
    // MARK: PROPERTIES
    
    var isMyProfile: Bool
    @State var profileDisplayName: String
    @State var profileBio: String = ""
    @State var profileImage: UIImage = UIImage(named: "logo.default")!
    var profileUserID: String
    
    @ObservedObject var exercises: ExerciseArrayObject
    
    // Picker setup
    
    @State var selection: String = "My Exercises"
    let filterOptions: [String] = [
        "My Exercises",
        "My Routines",
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        // The header view takes the arguments of the state variables passed in through contentview
                        ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, profileBio: $profileBio, exerciseCount: exercises.dataArray.count)
                            .background(Color.MyTheme.redColor)
                            .foregroundColor(.white)
                        
                        Picker(selection: $selection,
                               label: Text("Picker"),
                               content: {
                            ForEach(filterOptions.indices) { index in
                                Text(filterOptions[index])
                                    .tag(filterOptions[index])
                            }
                            
                        })
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal, 25)
                            .padding(.vertical, 5)
                        
                        if selection == "My Exercises" {
                            ScrollView(.vertical, showsIndicators: true, content: {
                                
                                // Help to the user if they have no exercises - directing them to the create view
                                if exercises.dataArray.isEmpty {
                                    VStack {
                                        VStack {
                                            
                                            Spacer()
                                            
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(minWidth: 200, maxWidth: 200)
                                                .foregroundColor(.primary)
                                                .padding(.horizontal, 115)
                                                .padding(.vertical)
                                            
                                            Text("Your exercise library is empty!")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.primary)
                                                .padding()
                                            
                                            Text("Add an exercise in the create view to get started.")
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                                .padding([.leading,.trailing,.bottom])
                                            
                                        }
                                        .padding(.bottom, 150)
                                    }
                                } else {
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        
                                        ForEach(exercises.dataArray) { exercise in
                                            
                                            // View showing detail of individual exercises
                                            LowerProfileView(exercise: exercise)
                                            
                                            
                                        }
                                        
                                    }
                                    .background(Color.MyTheme.greyColor)
                                }
                            })
                                .animation(.easeInOut)
                                .edgesIgnoringSafeArea(.bottom)
                                .transition(.slide)
                            
                        } else {
                            ScrollView(.vertical, showsIndicators: true, content: {
                                VStack {
                                    
                                    Spacer()
                                    
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 200, maxWidth: 200)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 115)
                                        .padding(.vertical)
                                    
                                    Text("Your routine library is empty!")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.primary)
                                        .padding()
                                    
                                    Text("Add a routine in the create view to get started.")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                        .padding([.leading,.trailing,.bottom])
                                    
                                }
                                .padding(.bottom, 150)
                                
                            })
                                .animation(.easeInOut)
                                .edgesIgnoringSafeArea(.bottom)
                                .transition(.slide)
                            
                        }
                        
                    }
                    
                }
                .navigationBarTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                    
                }, label: {
                    NavigationLink( // Passing in user details to settings view
                        destination: SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage),
                        label: {
                            Image(systemName: "line.horizontal.3")
                        })
                })
                                        .accentColor(Color.MyTheme.redColor)
                                        .opacity(isMyProfile ? 1.0 : 0.0)
                )
                .onAppear {
                    getProfileImage()
                    getAdditionalProfileInfo()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        // Reload exercises and routines when the view appears to account for any new data.
        .onAppear {
          reload()
        }
        
        
    }
    
    // MARK: FUNCTIONS
    
    func getProfileImage() { // Download profile image via DB
        ImageManager.instance.downloadProfileImage(userID: profileUserID) { returnedImage in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
    
    func reload() { // Redownload exercises from DB
        
        guard let userID = currentUserID else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            
            DataService.instance.downloadExerciseForUser(userID: userID, handler: { returnedExercises in
                exercises.dataArray = returnedExercises
                
            })
            
        }
    }
    
    func getAdditionalProfileInfo() { // Get the users info again in case the user changes their name or profile pic or adds a bio.
        AuthService.instance.getUserInfo(forUserID: profileUserID) { returnedDisplayName, returnedBio in
            if let displayName = returnedDisplayName {
                self.profileDisplayName = displayName
            }
            
            if let bio = returnedBio {
                self.profileBio = bio
            }
        }
    }
    
}

struct LowerProfileView: View {
    @State var exercise: ExerciseModel
    
    @State var exerciseImage: UIImage = UIImage(named: "logo.default")!
    var body: some View {
        
        HStack(spacing: 20) {
            Image(uiImage: exerciseImage)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100, alignment: .center)
                .cornerRadius(5)
                .padding(.leading, 20)
                .padding([.top, .bottom], 20)
            
            VStack(alignment: .leading) {
                Text(exercise.exerciseTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack(spacing: 16) {
                    Text(exercise.repsInfo)
                        .font(.subheadline)
                        .fontWeight(.regular)
                    
                    Text("|")
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    Text(exercise.setsInfo)
                        .font(.subheadline)
                        .fontWeight(.regular)
                }
                
            }
            
            Spacer()
        }
        .foregroundColor(.white)
        .onAppear {
            getExerciseImage(exercise: exercise)
        }
        
    }
    
    func getExerciseImage(exercise: ExerciseModel) {
        ImageManager.instance.downloadExerciseImage(exerciseID: exercise.exerciseID) { image in
            if let image = image {
                self.exerciseImage = image
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileDisplayName: "Joe", profileUserID: "", exercises: ExerciseArrayObject())
        }
    }
}

