//
//  ConnectionModel.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import Foundation
import SwiftUI

struct ConnectionModel: Identifiable, Hashable {
    
    var id = UUID()
    var userID: String
    var displayName: String
    var profileImage: UIImage
    var bio: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
