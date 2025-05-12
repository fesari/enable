//
//  RoutineModel.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import Foundation
import SwiftUI

struct RoutineModel: Identifiable, Hashable {
    
    var id = UUID()
    var routineID: String // ID for the routine in DB
    var userID: String // ID for the user in DB
    var username: String // username of user in DB
    var routineTitle: String
    var exercises: [ExerciseModel] // the exercises contained in the routine
    var dateCreate: Date
    var noOfExercises: String // How many exercises are contained within the routine
    var optionalImage: UIImage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
