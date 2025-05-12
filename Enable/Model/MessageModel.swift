//
//  MessageModel.swift
//  Enable
//
//  Created by Max Sinclair on 10/1/22.
//

import Foundation
import SwiftUI

struct MessageModel: Identifiable, Hashable {
    
    var id: String { documentId }
    var documentId: String
    var fromId: String
    var toId: String
    var text: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
