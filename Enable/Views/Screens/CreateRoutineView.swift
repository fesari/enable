//
//  CreateRoutineView.swift
//  Enable
//
//  Created by Max Sinclair on 3/1/22.
//

import SwiftUI

struct CreateRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var loading: Bool = false
    
    @State var showSheet: Bool = false
    
    // Routine Name Properties
    @State var title = ""
    var placeholder = "Enter Routine Name: "
    let lineThickness = CGFloat(2.0)
    
    // Routine Image Properties
    @State var imageSelected: UIImage = UIImage(named: "logo.default")!
    
    // Routine Exercise Array Properties
    @State var selectionArray = Set<ExerciseModel>()
    
    // Alert properties
    @State var showAlert: Bool = false
    @State var routineUploadedSuccessfully: Bool = false
    @State var userDoesNotExist: Bool = false
    @State var noExercisesSelected: Bool = false
    
    // Accessing UserDefaults using AppStorage
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var body: some View {
        
        ZStack {
        
        VStack {
            //CustomNavBar(title: "Create Routine")
            
            // MARK: ROUTINE NAME
            Group {
                HStack {
                    Text("Enter routine name: ")
                        .fontWeight(.semibold)
                        .padding([.top, .leading, .trailing])
                    
                    Spacer()
                }
                
                Divider()
                
                VStack {
                    TextField(placeholder, text: $title)
                    
                    HorizontalLine(color: Color.MyTheme.redColor)
                }
                .padding(.bottom, lineThickness)
                .padding(.all)
            }
            
            // MARK: ROUTINE IMAGE
            Group {
                VStack(spacing: 10) {
                    HStack {
                        Text("Submit an image for your routine:")
                            .fontWeight(.semibold)
                            .padding([.top,.leading,.trailing])
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack(alignment: .center) {
                        ImagePickerViewStyle(imageSelected: $imageSelected)
                            .padding([.top,.bottom])
                            .padding(.leading)
                            .frame(alignment: .center)
                        
                        VStack {
                            Text("Image Preview")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding([.trailing,.leading])
                            
                            Image(uiImage: imageSelected)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(25)
                                .padding([.trailing,.leading])
                        }
                    }
                    
                }
            }
            
            // MARK: SELECT EXERCISES
            
            Group {
                VStack(spacing: 10) {
                    HStack {
                        Text("Select one or more exercises for the routine:")
                            .fontWeight(.semibold)
                            .padding([.top,.leading,.trailing])
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    
                    
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        ExerciseSelectStyle()
                    })
                    .fullScreenCover(isPresented: $showSheet, content: {
                        if let userID = currentUserID {
                            SelectExerciseView(exercises: ExerciseArrayObject(userID: userID), selectionArray: $selectionArray)
                        } else {
                            SelectExerciseView(exercises: ExerciseArrayObject(), selectionArray: $selectionArray)
                        }
                    })
                    
                    
                }
            }
            
            // MARK: SUBMIT BUTTON
            //Spacer()
            
            Button(action: {
                self.loading = true
                createRoutine()
            }, label: {
                Text("CONTINUE".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.redColor)
                    .foregroundColor(.white)
            })
            .padding(.top)
            
            
            
        }
            
            
            if loading {
                
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.8)
                    
                    ProgressView()
                        .scaleEffect(3)
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                }
                
            }
            
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            getAlert()
        }
        .accentColor(Color.MyTheme.redColor)
    }
    
    // MARK: FUNCTIONS
    func createRoutine() {
        print("POST ROUTINE TO DATABASE HERE")
        print("---> Title: \(title)")
        print("---> Selected Image: \(imageSelected)")
        print("---> SelectionArray: \(selectionArray)")
        
        guard let userID = currentUserID, let displayName = currentUserDisplayName else {
            print("Error getting user ID while uploading routine")
            self.userDoesNotExist = true
            self.showAlert.toggle()
            return
        }
        
        if title == "" {
            title = "Unnamed Routine"
        }
        
        if selectionArray.isEmpty {
            self.noExercisesSelected = true
            self.showAlert.toggle()
            return
        }
        
        DataService.instance.createRoutine(title: title, image: imageSelected, exercises: selectionArray, userID: userID, displayName: displayName) { success in
            self.loading = false
            self.routineUploadedSuccessfully = success
            self.showAlert.toggle()
        }
    }
    
    func getAlert() -> Alert {
        if routineUploadedSuccessfully {
            return Alert(title: Text("Successfully uploaded routine 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }))
        } else if userDoesNotExist {
            return Alert(title: Text("You must be logged in in order to create an exercise! 😢"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        } else if noExercisesSelected {
            return Alert(title: Text("You must select at least one exercise to create a routine! 😢"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        } else {
            return Alert(title: Text("Error uploading exercise 😨"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    struct ExerciseSelectStyle: View {
        var body: some View {
            HStack {
                Text("Select exercises")
                    .padding(15)
                    .padding(.horizontal, 50)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(Color.MyTheme.redColor)
                    .cornerRadius(8)
                    .shadow(color: Color.MyTheme.greyColor.opacity(0.3), radius: 10, x: 0, y: 10)
                    .overlay(
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 15)
                    )
            }
            .padding([.top,])
        }
    }
}

/*struct CreateRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoutineView()
    }
}*/
