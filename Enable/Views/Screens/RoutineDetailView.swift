//
//  RoutineDetailView.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import SwiftUI

// Similar to exercise detail view, the routine detail view presents more information about the contents of a particular routine. In this case, the 'detail' presented are the exercises contained within the routine itself.

struct RoutineDetailView: View {
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @State var routine: RoutineModel
    @State var selectedExercise: ExerciseModel?
    @State var showSheet: Bool = false
    @State var exerciseImage: UIImage = UIImage(named: "logo.default")!
    @AppStorage(DatabaseUserField.userID) var currentUserID: String?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // The data type associate with the routine State attribute - RoutineModel, contains a value of exercises equal to an array of ExerciseModel, therefore we can loop through this array and list each exercise.
                    ForEach(routine.exercises, id: \.self) { exercise in
                        Button {
                            
                            // Setting the selected exercise so the sheet knows which exercise to present
                            self.selectedExercise = exercise
                            
                            // Toggle state property
                            showSheet.toggle()
                            
                            
                        } label: {
                            HStack(spacing: 10) {
                                
                                // Checking if default routines are required.
                                if let userID = currentUserID {
                                    Image(uiImage: exerciseImage)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(4)
                                        .frame(width: 100, height: 100)
                                        .padding()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    Image(uiImage: exercise.optionalImage ?? UIImage(named: "logo.default")!)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(4)
                                        .frame(width: 100, height: 100)
                                        .padding()
                                        .aspectRatio(contentMode: .fill)
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("\(exercise.exerciseTitle)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    
                                    HStack {
                                        
                                        Text("\(exercise.repsInfo),")
                                            .fontWeight(.light)
                                            .scaledToFill()
                                            .foregroundColor(.primary)
                                        
                                        Text("\(exercise.setsInfo)")
                                            .fontWeight(.light)
                                            .scaledToFill()
                                            .foregroundColor(.primary)
                                        
                                    }
                                }
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.primary)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 15)
                            }
                        }
                        // The sheet is presented when the button is pressed, as the action contains a toggle for showSheet state property. We then make sure the selectedExercise is selected before presenting the detail view for that particular exercise.
                        .sheet(isPresented: $showSheet) {
                            if let selectedExercise = selectedExercise {
                                ExerciseDetailView(exercise: selectedExercise)
                            }
                            
                            
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationTitle(routine.routineTitle)
                    
                }
                
            }
            // Here, on the view appearing we download the exercise images per the downloadExerciseImages function for each exercise in the exercise array of a particular routine.
            .onAppear {
                for eachExercise in routine.exercises {
                    self.selectedExercise = eachExercise
                    downloadExerciseImages(selectedExercise: selectedExercise!)
                }
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: FUNCTIONS
    // Here we fetch the data from firebase.
    func downloadExerciseImages(selectedExercise: ExerciseModel) {
        
        ImageManager.instance.downloadExerciseImage(exerciseID: selectedExercise.exerciseID) { returnedImage in
            if let image = returnedImage {
                self.exerciseImage = image
            }
        }
    }
}
