//
//  ExerciseArrayObject.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import Foundation
import SwiftUI

class ExerciseArrayObject: ObservableObject {
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @Published var dataArray = [ExerciseModel]()
    
    
    /// USED FOR GETTING EXERCISES FOR USER PROFILE
   init(userID: String) {
        
       print("GET EXERCISES FOR \(userID)")
       DataService.instance.downloadExerciseForUser(userID: userID) { returnedExercises in
           let sortedExercises = returnedExercises.sorted { exercise1, exercise2 in
               return exercise1.dateCreate > exercise2.dateCreate
           }
           
           self.dataArray.append(contentsOf: sortedExercises)
       }
  
    }
    
    init() {
        fetchDefaultExercises()
    }
    
    
    func fetchDefaultExercises() {
        print("FETCH DEFAULT EXERCISES - NO USER ID FOUND")
        let pushup = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Push-ups", dateCreate: Date(),  repsInfo: "10 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "pushup"))
        let pullup = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Pull-ups", dateCreate: Date(),  repsInfo: "5 reps", setsInfo: "4 sets", optionalImage: UIImage(named: "pullup"))
        let row = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Rowing Machine", dateCreate: Date(),  repsInfo: "1 rep", setsInfo: "1 set", optionalImage: UIImage(named: "row"))
        let run = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Running", dateCreate: Date(),  repsInfo: "1 rep", setsInfo: "1 set", optionalImage: UIImage(named: "run"))
        let deadlift = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Deadlifts", dateCreate: Date(),  repsInfo: "8 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "deadlift"))
        let squat = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Squats", dateCreate: Date(),  repsInfo: "10 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "squat"))
        let curls = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Bicep curls", dateCreate: Date(),  repsInfo: "12 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "bicep"))
        
        self.dataArray.append(pushup)
        self.dataArray.append(pullup)
        self.dataArray.append(row)
        self.dataArray.append(run)
        self.dataArray.append(deadlift)
        self.dataArray.append(squat)
        self.dataArray.append(curls)
    }
    
    
    /* // waiting on an exercise model to be initialised
     static func fetchTempExercises() -> [ExerciseModel] {
         
         
         var exercises = [ExerciseModel]()
         
         let pushup = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Push-ups", dateCreate: Date(), exerciseImage: UIImage(named: "pushup")!, repsInfo: "10 reps", setsInfo: "3 sets")
         let pullup = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Pull-ups", dateCreate: Date(), exerciseImage: UIImage(named: "pullup")!, repsInfo: "5 reps", setsInfo: "4 sets")
         let row = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Rowing Machine", dateCreate: Date(), exerciseImage: UIImage(named: "row")!, repsInfo: "1 rep", setsInfo: "1 set")
         let run = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Running", dateCreate: Date(), exerciseImage: UIImage(named: "run")!, repsInfo: "1 rep", setsInfo: "1 set")
         let deadlift = ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Deadlifts", dateCreate: Date(), exerciseImage: UIImage(named: "deadlift")!, repsInfo: "8 reps", setsInfo: "3 sets", sharedUserUsername: "Shared User")
         
         exercises.append(pushup)
         exercises.append(pullup)
         exercises.append(row)
         exercises.append(run)
         exercises.append(deadlift)
         
         // the exercise model is initialised
         return exercises
     } */
}
