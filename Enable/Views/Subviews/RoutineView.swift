//
//  RoutineView.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import SwiftUI

// The purpose of this view is to contain the details of a singular routine that will be presnted on the LibraryView for a single user. This view is presented as a button which can be interacted with to see details of the exercises in that routine.

struct RoutineView: View {
    
    // MARK: PROPERTIES
    @State var routine: RoutineModel
    @State var routineImage: UIImage = UIImage(named: "logo.default")!
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    var body: some View {
        
        VStack(spacing:0) {
            
            // If the user is logged in, we will present the downloaded image from Firebase, otherwise we will use the optionalImage attribute of the RoutineModel struct assigned to default routines for guest users.
            
            if let userID = currentUserID {
                Image(uiImage: routineImage)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .clipShape(RoundedBottomShape())
            } else {
                if let fallbackImage = routine.optionalImage {
                    Image(uiImage: fallbackImage)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                        .clipShape(RoundedBottomShape())
                } else {
                    Image(uiImage: UIImage(named: "logo.default")!)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                        .clipShape(RoundedBottomShape())
                }
            }
            
            // Here we display the name of the particular routine.
            
            ZStack {
                RoundedTopShape() // FROM CHATVIEW
                    .foregroundColor(Color.MyTheme.redColor)
                
                Text(routine.routineTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .scaledToFit()
                    .padding()
            }
            
        }
        // When this view appears the function to get images from the database is called.
        .onAppear {
            getRoutineImages()
        }
    }
    
    func getRoutineImages() {
        // Get routine image from Firebase using our function defined in ImageManager.
        ImageManager.instance.downloadRoutineImage(routineID: routine.routineID) { returnedImage in
            // Ensuring the image exists before setting
            if let image = returnedImage {
                self.routineImage = image
            }
        }
    }
}

struct RoutineView_Previews: PreviewProvider {
    
    static var routine: RoutineModel = RoutineModel(routineID: "", userID: "", username: "Max Sinclair", routineTitle: "Core Workout", exercises: [ExerciseModel](), dateCreate: Date(), noOfExercises: "\([ExerciseModel]().count)")
    
    static var previews: some View {
        RoutineView(routine: routine)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
