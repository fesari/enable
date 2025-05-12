//
//  LibraryView.swift
//  Enable
//
//  Created by Max Sinclair on 29/12/21.
//

import SwiftUI

struct LibraryView: View {
    // MARK: Environment properties
    @Environment(\.presentationMode) var presentation
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    // MARK: PROPERTIES
    @ObservedObject var exercises: ExerciseArrayObject
    @ObservedObject var routines: RoutineArrayObject
    
    // Specifying what kind of grid structure we want for our LazyVGrid UI elements (i.e. columns, grid behaviour etc.)
    var columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State var searchText = ""
    @State var selectedExercise: ExerciseModel?
    @State var selectedRoutine: RoutineModel?
    @State var showSheet: Bool = false
    @State var selection: String = "Exercises"
    let filterOptions: [String] = [
        "Exercises", "Routines"
    ]
    
    @State var profileImage: UIImage = UIImage(named: "logo.default")!
    @State var exerciseImage: UIImage = UIImage(named: "logo.default")!
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: HEADER
                // Calling the 'SearchBar' subview using @State var text as a parameter.
                SearchBar(text: $searchText)
                
                Picker(selection: $selection,
                       label: Text("Picker"),
                       content: {
                    Text("Exercises")
                        .tag("Exercises")
                    Text("Routines")
                        .tag("Routines")
                    
                    
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding([.top,.bottom], 5)
                
                
                // MARK: EXERCISE BODY
                // Changing view based on picker selection.
                if selection == "Exercises" {
                    
                    if exercises.dataArray.isEmpty {
                        
                        VStack {
                            
                            Spacer()
                            
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 200, maxWidth: 200)
                                .foregroundColor(Color.MyTheme.redColor)
                                .padding(.horizontal, 115)
                                .padding(.bottom, 25)
                            
                            Text("Your exercise library is empty!")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .padding()
                            
                            Text("Add an exercise in the create view to get started.")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding()
                            
                        }
                        .padding(.bottom, 300)
                        
                    } else {
                        
                        ScrollView(.vertical, showsIndicators: false){
                            LazyVGrid(columns: columns, spacing: 10){
                                
                                ForEach(exercises.dataArray.filter({"\($0)".contains(searchText) || searchText.isEmpty}), id: \.self){ i in
                                    
                                    Button {
                                        selectedExercise = i
                                        showSheet.toggle()
                                    } label: {
                                        ExerciseView(exercise: i)
                                    }
                                    .sheet(item: $selectedExercise) { exercise in
                                        ExerciseDetailView(exercise: exercise)
                                    }
                                    
                                }
                            }
                        }
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut)
                        
                        
                    }
                    

                } else {
                    ScrollView(.vertical, showsIndicators: false){
                        
                        LazyVGrid(columns: columns, spacing: 10){
                            
                            ForEach(routines.dataArray.filter({"\($0)".contains(searchText) || searchText.isEmpty}), id: \.self){
                                i in
                                
                                NavigationLink(
                                    destination: RoutineDetailView(routine: i),
                                    label: {
                                        RoutineView(routine: i)
                                    })
                                
                            }
                        }
                        
                    }
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut)
                    
                    
                    Spacer()
                }
                
                
            }
            .padding([.top, .leading, .trailing])
            .navigationBarTitle("My Library")
            .navigationBarTitleDisplayMode(.inline)
            // Specifying the action of a refresh button to redownload data from DB.
            .navigationBarItems(
                trailing: Button(
                    action: {
                        reloadLibrary()
                    },
                    label: {Image(systemName: "arrow.clockwise").foregroundColor(Color.MyTheme.redColor)}
                )
            )
            
            
            
            
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
           // getImages()
            
        }
    }
    // MARK: FUNCTIONS
    
    // if the refresh button is pressed the reload function will force the view to redownload any new data.

    func reloadLibrary() {
        
        guard let userID = currentUserID else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            
            DataService.instance.downloadExerciseForUser(userID: userID, handler: { returnedExercises in
                exercises.dataArray = returnedExercises
                
            })
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            DataService.instance.downloadRoutineForUser(userID: userID) { returnedRoutines in
                routines.dataArray = returnedRoutines
            }
        }
    }
    
    
}



struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(exercises: ExerciseArrayObject(), routines: RoutineArrayObject())
            .preferredColorScheme(.dark)
        
    }
}

