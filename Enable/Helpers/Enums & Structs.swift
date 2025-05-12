//
//  Enums & Structs.swift
//  Enable
//
//  Created by maxsinclair1 on 12/3/2022.
//

import Foundation

struct DatabaseUserField { // Fields within the user document in Database
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
    
}

struct DatabaseExerciseField { // Fields within exercise document in Database
    
    static let title = "title"
    static let reps = "reps"
    static let sets = "sets"
    static let displayName = "display_name"
    static let userID = "user_id"
    static let dateCreated = "date_created"

}

struct DatabaseRoutineField { // Fields within routine document in Database
    static let title = "title"
    static let displayName = "display_name"
    static let userID = "user_id"
    static let dateCreated = "date_created"
}

struct DatabaseMessageField { // Fields within message document in Database
    
    static let fromId = "fromId"
    static let text = "text"
    static let toId = "toId"
    static let timestamp = "timestamp"
    
}

struct CurrentUserDefaults { // Fields for UserDefaults saved within the app
    
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
    static let hasSeenWalkthrough = "hasSeenWalkthrough"
    
}

enum SettingsEditTextOption {
    case displayName
    case bio
}
