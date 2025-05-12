//
//  ExerciseView.swift
//  Enable
//
//  Created by Max Sinclair on 29/12/21.
//

import SwiftUI

// Similar in nature to RoutineView, the ExerciseView screen presents the details of a singular exercise model and is called from the LibraryView to present all of the exercises created for a single user.

struct ExerciseView: View {
    
    // MARK: PROPERTIES
    @State var exercise: ExerciseModel
    @State var exerciseImage: UIImage = UIImage(named: "logo.default")! // FOR UPLOAD
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // In the case where the user is not logged in, the optional images are presented in accordance to the default exercise view model initialiser (see ExerciseArrayObject for more details)
            
            if let userID = currentUserID {
                Image(uiImage: exerciseImage)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .clipShape(RoundedBottomShape())
            } else {
                Image(uiImage: exercise.optionalImage ?? UIImage(named: "logo.default")!)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .clipShape(RoundedBottomShape())
            }
            
            // Presenting the name of the exercise with extra styling using a custom shape (see ChatView for struct definition)
            
            ZStack {
                RoundedTopShape()
                    .foregroundColor(Color.MyTheme.redColor)
                
                Text(exercise.exerciseTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .scaledToFit()
                    .padding()
            }
            
            Spacer()
            
        } // On the view appearing we will call the function to pull the images from the DB for exercises.
        .onAppear {
            getImages()
        }
        
    }
    
    // MARK: FUNCTIONS
    
    func getImages() {
        
        // Get exercise image from Firebase via ImageManager function
        ImageManager.instance.downloadExerciseImage(exerciseID: exercise.exerciseID) { (returnedImage) in
            // Ensuring the image exists before setting
            if let image = returnedImage {
                self.exerciseImage = image
            }
        }
        
    }
}

