//
//  ExerciseModel.swift
//  Enable
//
//  Created by Max Sinclair on 30/12/21.
//

import Foundation
import SwiftUI

struct ExerciseModel: Identifiable, Hashable {
    
    var id = UUID()
    var exerciseID: String // ID for the exercise in DB
    var userID: String // ID for the user in DB
    var username: String // username of user in DB
    var exerciseTitle: String
    var dateCreate: Date
    var repsInfo: String // How many repetitions for the exercise
    var setsInfo: String // How many sets for the exercise
    var optionalImage: UIImage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
