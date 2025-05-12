//
//  ContentView.swift
//  Enable
//
//  Created by Max Sinclair on 29/12/21.
//

import SwiftUI

struct ContentView: View {
    
    // Tracking currently logged in user
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    // Tracking whether it is the user's first open of the application, to determine if a walkthrough needs to be shown.
    @AppStorage(CurrentUserDefaults.hasSeenWalkthrough) private var hasSeenWalkthrough = false
    
    // non user init for users who are not logged in
    var sampleExerciseData = ExerciseArrayObject()
    var sampleRoutineData = RoutineArrayObject()
    
    var body: some View {
        TabView {
            // Validating if the user is logged in
            if let userID = currentUserID, let displayName = currentUserDisplayName {
                LibraryView(exercises: ExerciseArrayObject(userID: userID), routines: RoutineArrayObject(userID: userID))
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Library")
                    }
                    .foregroundColor(Color.MyTheme.greyColor)
            } else {
                LibraryView(exercises: sampleExerciseData, routines: sampleRoutineData)
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Library")
                    }
                    .foregroundColor(Color.MyTheme.greyColor)
            }
            
            CreateView()
                .tabItem {
                    Image(systemName: "plus")
                    Text("Create")
                }
            
            if let userID = currentUserID {
                ConnectionsView(connections: ConnectionArrayObject())
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Connect")
                    }
            } else {
                // If the user is not logged in, they should not access the connections menu, only a sign up view.
                SignUpView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Connect")
                    }
            }
            
            
            
            if let userID = currentUserID, let displayName = currentUserDisplayName {
                // Passing through the userID once the user is validated so that the profile view information can be geenrated.
                ProfileView(isMyProfile: true, profileDisplayName: displayName, profileUserID: userID, exercises: ExerciseArrayObject(userID: userID))
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            } else {
                SignUpView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            }
            
            
        }
        .accentColor(Color.MyTheme.redColor)
        
        // Initialising plist information for static data and walkthrough if the user has not seen the walkthrough before.
        .fullScreenCover(isPresented: .constant(!hasSeenWalkthrough),
                         content: {
            let plistManager = PlistManagerImpl()
            let walkthroughContentManager = WalkthroughContentManagerImpl(manager: plistManager)
            
            WalkthroughScreenView(manager: walkthroughContentManager) {
                hasSeenWalkthrough = true
            }
        })
        .onAppear {
                        // correct the transparency bug for Tab bars
                        let tabBarAppearance = UITabBarAppearance()
                        tabBarAppearance.configureWithOpaqueBackground()
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            } else {
                // Fallback on earlier versions
            }
                    }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
