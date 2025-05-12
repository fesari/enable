//
//  CreateExerciseView.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import UIKit
import SwiftUI

struct CreateExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var loading: Bool = false
    
    // Exercise Name Properties
    @State var title = ""
    var placeholder = "Enter Exercise Name: "
    let lineThickness = CGFloat(2.0)
    
    // Exercise Image Properties
    @State var imageSelected: UIImage = UIImage(named: "logo.default")! // Set an explicit image, mainly for the purpose of a functional preview
    
    // Reps/Sets Properties
    @State var reps: String = "1 rep"
    @State var sets: String = "1 set"
    
    // Accessing UserDefaults using AppStorage
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    // Alert
    @State var showAlert: Bool = false
    @State var exerciseUploadedSuccessfully: Bool = false
    @State var userDoesNotExist: Bool = false
    
    
    
    var body: some View {
        ZStack {
            
            VStack {
                
                // MARK: HEADER
                //CustomNavBar(title: "Create Exercise")
                
                
                // MARK: EXERCISE NAME
                HStack {
                    Text("Enter exercise name: ")
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
                
                
                
                // MARK: IMAGE/VIDEO
                HStack {
                    Text("Submit an image of your exercise: ")
                        .fontWeight(.semibold)
                        .padding([.top, .trailing, .leading])
                    
                    Spacer()
                }
                
                Divider()
                
                
                HStack(alignment: .center) {
                    ImagePickerViewStyle(imageSelected: $imageSelected)
                        .padding([.top,.trailing,.bottom,.leading])
                        .frame(alignment: .center)
                    
                    
                    VStack {
                        Text("Image Preview")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding([.trailing])
                        
                        Image(uiImage: imageSelected)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(25)
                            .padding([.trailing])
                    }
                    
                }
                
                
                
                
                
                Group {
                    // MARK: REPS AND SETS
                    RepsViewStyle(reps: $reps, sets: $sets)
                    
                    
                }
                .padding(.horizontal)
                
                
                
                //Spacer()
                
                // MARK: SUBMIT BUTTON
                Button(action: {
                    self.loading = true
                    createExercise()
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
            .alert(isPresented: $showAlert) { () -> Alert in
                getAlert()
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
        
    }
    
    
    // MARK: FUNCTIONS
    func createExercise() {
        
        
        print("POST EXERCISE TO DATABASE HERE")
        print("---> Title: \(title)")
        print("---> Selected Image: \(imageSelected)")
        print("---> Reps: \(reps)")
        print("---> Sets: \(sets)")
        
        guard let userID = currentUserID, let displayName = currentUserDisplayName else {
            print("Error getting user ID or display name while posting image")
            self.userDoesNotExist = true
            self.showAlert.toggle()
            return
        }
        
        if title == "" { // data validation
            title = "Unnamed Exercise"
        }
        
        DataService.instance.createExercise(title: title, image: imageSelected, reps: reps, sets: sets, displayName: displayName, userID: userID, sharedUser: "") { (success) in
            self.loading = false
            self.exerciseUploadedSuccessfully = success
            self.showAlert.toggle()
            
            
        }
        
    }
    
    func getAlert() -> Alert {
        if exerciseUploadedSuccessfully {
            return Alert(title: Text("Successfully uploaded exercise 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }))
        } else if userDoesNotExist {
            return Alert(title: Text("You must be logged in in order to create an exercise! 😢"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        } else {
            return Alert(title: Text("Error uploading exercise 😨"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}


struct CreateExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExerciseView()
            .preferredColorScheme(.light)
    }
}

