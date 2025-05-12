//
//  DataService.swift
//  Enable
//
//  Created by maxsinclair1 on 13/3/2022.
//

// Will be used to handle uploading and downloading data other than users from our DB
import Foundation
import SwiftUI
import FirebaseFirestore

class DataService {
    
    // MARK: PROPERTIES
    static let instance = DataService()
    
    private var REF_EXERCISES = DB_BASE.collection("exercises")
    private var REF_ROUTINES = DB_BASE.collection("routines")
    
    
    // MARK: CREATE FUNCTIONS
    
    func createExercise(title: String, image: UIImage, reps: String, sets: String, displayName: String, userID: String, sharedUser: String?, handler: @escaping (_ success: Bool) -> ()) {
        
        // Create a new exercise document
        let document = REF_EXERCISES.document()
        let exerciseID = document.documentID
        
        // Upload image to storage
        ImageManager.instance.uploadExerciseImage(exerciseID: exerciseID, image: image) { (success) in
            
            if success {
                // Successfully uploaded image data to storage
                // Now upload exercise data to DB
                let exerciseData: [String: Any] = [
                    DatabaseExerciseField.title : title,
                    DatabaseExerciseField.reps : reps,
                    DatabaseExerciseField.sets : sets,
                    DatabaseExerciseField.displayName : displayName,
                    DatabaseExerciseField.userID : userID,
                    DatabaseExerciseField.dateCreated : FieldValue.serverTimestamp()
                ]
                
                document.setData(exerciseData) { (error) in
                    if let error = error {
                        print("Error uploading data to exercise document. \(error)")
                        handler(false)
                        return
                    } else {
                        // return back to the app
                        handler(true)
                        return
                    }
                }
                
            } else {
                print("Error uploading exercise image to Firebase")
                handler(false)
                return
            }
        }
        
    }
    
    func createRoutine(title: String, image: UIImage, exercises: Set<ExerciseModel>, userID: String, displayName: String, handler: @escaping (_ success: Bool) -> ()) {
        
        // Create a new routine document (Routines —> routine document —> exercises collection)
        let document = REF_ROUTINES.document()
        let routineID = document.documentID
        
        let subcollection = document.collection("exercises")
        
        // Upload image to storage
        ImageManager.instance.uploadRoutineImage(routineID: routineID, image: image) { success in
            
            if success {
                // Successful upload
                // Upload routine data to DB
                let routineData: [String: Any] = [
                    DatabaseRoutineField.title : title,
                    DatabaseRoutineField.userID : userID,
                    DatabaseRoutineField.dateCreated : FieldValue.serverTimestamp(),
                    DatabaseRoutineField.displayName : displayName
                ]
                
                document.setData(routineData) { error in
                    if let error = error {
                        print("Error uploading data to routine document with error: \(error)")
                        handler(false)
                        return
                    }
                }
                    
                for exercise in exercises {
                    let exerciseDocument = subcollection.document(exercise.exerciseID)
                    
                    let exerciseData: [String: Any] = [
                        DatabaseExerciseField.title : exercise.exerciseTitle,
                        DatabaseExerciseField.reps : exercise.repsInfo,
                        DatabaseExerciseField.sets : exercise.setsInfo,
                        DatabaseExerciseField.displayName : exercise.username,
                        DatabaseExerciseField.userID : exercise.userID,
                        DatabaseExerciseField.dateCreated : exercise.dateCreate
                    ]
                    
                    exerciseDocument.setData(exerciseData) { error in
                        if let error = error {
                            print("Error uploading data to exercise document for exercise \(exercise) with error: \(error)")
                            handler(false)
                            return
                        }
                    }
                }
                handler(true)
                print("Successfully uploaded routine data to Firebase")
            } else {
                print("Error uploading routine image to Firebase")
                handler(false)
                return
            }
        }
        
    }
    
    // MARK: GET FUNCTIONS
    
    // Download all exercises for a single user based on a query to the exercises collection
    func downloadExerciseForUser(userID: String, handler: @escaping (_ exercises: [ExerciseModel]) -> ()) {
        
        REF_EXERCISES.whereField(DatabaseExerciseField.userID, isEqualTo: userID).getDocuments { querySnapshot, error in
            
            handler(self.getExerciseFromSnapshot(querySnapshot: querySnapshot))
            
            
        }
        
    }
    
    // Get the exercise data from a snapshot query to firebase, and translate this data to my custom type.
    private func getExerciseFromSnapshot(querySnapshot: QuerySnapshot?) -> [ExerciseModel] {
        
        var exerciseArray = [ExerciseModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                
                if
                    let userID = document.get(DatabaseExerciseField.userID) as? String,
                    let displayName = document.get(DatabaseExerciseField.displayName) as? String,
                    let exerciseTitle = document.get(DatabaseExerciseField.title) as? String,
                    let timestamp = document.get(DatabaseExerciseField.dateCreated) as? Timestamp,
                    let repsInfo = document.get(DatabaseExerciseField.reps) as? String,
                    let setsInfo = document.get(DatabaseExerciseField.sets) as? String {
                    
                    let date = timestamp.dateValue()
                    let exerciseID = document.documentID
                    
                    
                        let newExercise = ExerciseModel(exerciseID: exerciseID, userID: userID, username: displayName, exerciseTitle: exerciseTitle, dateCreate: date, repsInfo: repsInfo, setsInfo: setsInfo)
                        
                        exerciseArray.append(newExercise)
                    }
                    
                    
                    
            }
            return exerciseArray
        } else {
            print("No documents in snapshot found for this user")
            return exerciseArray
        }
    }
    
    // Similar process as exercise for user
    func downloadRoutineForUser(userID: String, handler: @escaping (_ routines: [RoutineModel]) -> ()) {
            
        REF_ROUTINES.whereField(DatabaseRoutineField.userID, isEqualTo: userID).getDocuments { querySnapshot, error in
            self.getRoutineFromSnapshot(querySnapshot: querySnapshot) { returnedRoutines in
                handler(returnedRoutines)
            }
        }
    }
    
    
    // An extra step is required as two queries must be made: The routine query itself and the queries for each of the exercise documents within the routine.
    private func downloadExercisesForRoutine(routineID: String, handler: @escaping (_ exercises: [ExerciseModel]) -> ()) {
        
        REF_ROUTINES.document(routineID).collection("exercises").getDocuments { querySnapshot, error in
            handler(self.getExerciseFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    // converting the information from the database query to usable data types used in the project 
    private func getRoutineFromSnapshot(querySnapshot: QuerySnapshot?, handler: @escaping (_ routines: [RoutineModel]) -> ()) {
        
        var routineArray = [RoutineModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                if
                    // get data from document
                    let userID = document.get(DatabaseRoutineField.userID) as? String,
                    let displayName = document.get(DatabaseRoutineField.displayName) as? String,
                    let title = document.get(DatabaseRoutineField.title) as? String,
                    let dateCreated = document.get(DatabaseRoutineField.dateCreated) as? Date {
                    
                    let routineID = document.documentID
                    
                    // Get exercise data
                    self.downloadExercisesForRoutine(routineID: routineID) { returnedExercises in
                        
                        let newRoutine = RoutineModel(routineID: routineID, userID: userID, username: displayName, routineTitle: title, exercises: returnedExercises, dateCreate: dateCreated, noOfExercises: "\(returnedExercises.count)")
                        
                        routineArray.append(newRoutine)
                    }
                    
                } else {
                    print("Failed to get snapshot from exercise document within routine document")
                    handler(routineArray)
                }
                
            }
            handler(routineArray)
            
        } else {
            print("Failed to get snapshot from routine document")
            handler(routineArray)
        }
    }


    
    // MARK: DOCUMENT GETTERS
    
    // Fetch an exercise document from the firebase firestore for a single user.
    func getExerciseDocumentForUser(forUserID userID: String, handler: @escaping (_ returnedExerciseID: [String]) -> ()) {
        
        // finding the fields in the exercise collection where the userId field is equal to the userid passed into the function.
        let query = REF_EXERCISES.whereField(DatabaseExerciseField.userID, isEqualTo: userID)
        
        var returnedExerciseID: [String] = []
        
        
        query.getDocuments() { querySnapshot, error in
            if error != nil {
                
                print("Error getting exercise documents for userID \(userID)")
                
                handler(returnedExerciseID)
                
            } else {
                
                for eachDocument in querySnapshot!.documents {
                    
                    let exerciseID = eachDocument.documentID
                    
                    returnedExerciseID.append(exerciseID)
                    
                }
                
                handler(returnedExerciseID)
                
            }
            
            
        }
    }
    
    
    // MARK: UPDATE FUNCTIONS
    
    func updateDisplayNameOnExercises(userID: String, displayName: String) {
        
        // Get all posts for user
        downloadExerciseForUser(userID: userID) { returnedExercises in
            for exercises in returnedExercises {
                self.updateExerciseDisplayName(exerciseID: exercises.exerciseID, displayName: displayName)
            }
        }
        
    }
    
    private func updateExerciseDisplayName(exerciseID: String, displayName: String) {
        
        let data: [String: Any] = [
            DatabaseExerciseField.displayName : displayName
        ]
        
        REF_EXERCISES.document(exerciseID).updateData(data)
    }
    
    // MARK: DELETE FUNCTIONS
    
    func deleteExerciseDocumentData(forUserID userID: String) {
        
        let query = REF_EXERCISES.whereField(DatabaseExerciseField.userID, isEqualTo: userID)
        
        query.getDocuments() { querySnapshot, error in
            if error != nil {
                
                print("Error getting documents for userID \(userID)")
                
                
            } else {
                
                for eachDocument in querySnapshot!.documents {
                    self.REF_EXERCISES.document("\(eachDocument.documentID)").delete()
                }
                
            }
        }
        
        print("Successfully deleted all user data for userID \(userID)")
        
    }
    
}





