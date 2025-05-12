//
//  RoutineArrayObject.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import Foundation
import SwiftUI

class RoutineArrayObject: ObservableObject {
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @Published var dataArray = [RoutineModel]()

    /// USED FOR GETTING ROUTINES FOR USER PROFILE
    init(userID: String) {
        print("GET ROUTINES FOR \(userID)")
        
        DataService.instance.downloadRoutineForUser(userID: userID) { returnedRoutines in
            let sortedRoutines = returnedRoutines.sorted { routine1, routine2 in
                return routine1.dateCreate > routine2.dateCreate
            }
            
            self.dataArray.append(contentsOf: sortedRoutines)
        }
        
    }
    
    init() {
        
        fetchDefaultRoutines()
        
    }
    
    
    func fetchDefaultRoutines() {
        print("FETCH FROM DATABASE HERE")
        let calisthenicsExerciseList = [ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Push-ups", dateCreate: Date(),  repsInfo: "10 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "pushup")), ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Pull-ups", dateCreate: Date(),  repsInfo: "5 reps", setsInfo: "4 sets", optionalImage: UIImage(named: "pullup")), ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Rowing Machine", dateCreate: Date(),  repsInfo: "1 rep", setsInfo: "1 set", optionalImage: UIImage(named: "row")), ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Running", dateCreate: Date(),  repsInfo: "1 rep", setsInfo: "1 set", optionalImage: UIImage(named: "run"))]
        
        let weightsExerciseList = [ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Deadlifts", dateCreate: Date(),  repsInfo: "8 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "deadlift")), ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Squats", dateCreate: Date(), repsInfo: "10 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "squat")), ExerciseModel(exerciseID: "", userID: "", username: "Enable", exerciseTitle: "Bicep curls", dateCreate: Date(), repsInfo: "12 reps", setsInfo: "3 sets", optionalImage: UIImage(named: "bicep"))]
        
        
        let weights = RoutineModel(routineID: "", userID: "", username: "Enable", routineTitle: "Weights", exercises: weightsExerciseList, dateCreate: Date(), noOfExercises: "\(weightsExerciseList.count)", optionalImage: UIImage(named: "weights"))
        
        let calisthenics = RoutineModel(routineID: "", userID: "", username: "Enable", routineTitle: "Calisthenics", exercises: calisthenicsExerciseList, dateCreate: Date(), noOfExercises: "\(calisthenicsExerciseList.count)", optionalImage: UIImage(named: "calisthenic"))
        
        self.dataArray.append(weights)
        self.dataArray.append(calisthenics)
    }
}
