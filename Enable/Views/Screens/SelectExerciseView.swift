//
//  ExerciseSelectView.swift
//  Enable
//
//  Created by Max Sinclair on 3/1/22.
//

import SwiftUI

// This view is presented when the user selects the exercises they want to include in their routine as part of the create routine flow. It implements the ExerciseView and DetailView in order to improve code readability, with some extra additions of a button to select the exercise.

struct SelectExerciseView: View {
    
    // MARK: PROPERTIES
    @ObservedObject var exercises: ExerciseArrayObject
    @State var selectedExercise: ExerciseModel?
    @Binding var selectionArray: Set<ExerciseModel>
    @State var showSheet: Bool = false
    @State var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    // Columns sets up the structure of the LazyVGrid view element, specifying that we want 2 ExerciseView items per row.
    var columns = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        NavigationView {
            VStack {
                
                SearchBar(text: $searchText)
                    .padding([.top,.leading,.trailing])
                
                ScrollView(.vertical, showsIndicators: false){
                    
                    LazyVGrid(columns: columns, spacing: 10){
                        
                        // The .filter attribute allows us to filter through the Published variable dataArray containing an array of all of the appended exercises which is initialised in ExerciseArrayObject and can be searched through using the searchText of the search bar.
                        ForEach(exercises.dataArray.filter({"\($0)".contains(searchText) || searchText.isEmpty}), id: \.self) { i in
                            Button {
                                // Telling the view which exercisemodel type has been selected using the foreach.
                                selectedExercise = i
                            } label: {
                                ExerciseView(exercise: i)
                            }
                            // The item attribute of the .sheet modifier allows us to present a sheet to the user based on the selected exercise with unique information about that specific exercise.
                            .sheet(item: $selectedExercise) { exercise in
                                VStack {
                                    ExerciseDetailView(exercise: exercise)
                                    
                                    Button(action: {
                                        // If the selection array does not get contain the exercise, we will insert the exercise.
                                        if selectionArray.contains(exercise) == false {
                                            selectionArray.insert(exercise)
                                            print("--> selectionArray: \(selectionArray)")
                                        } else {
                                            
                                        }
                                    }, label: {
                                        // Making sure that the button changes when an exercise has been added.
                                        if selectionArray.contains(exercise) {
                                            Text("Exercise Added".uppercased())
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .transition(.opacity)
                                        } else {
                                            Text("Add to Routine".uppercased())
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                    })
                                    .padding()
                                    .frame(width: 300)
                                    .background(selectionArray.contains(exercise) ? Color.green : Color.blue)
                                    .cornerRadius(25)
                                }
                            }
                            
                            
                        }
                        
                        
                    }
                }.padding()
            }
            .navigationBarTitle("Select Exercises")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.title3)
                                    })
                                    .accentColor(.primary)
                                
                                
            )
            
        }
    }
}

