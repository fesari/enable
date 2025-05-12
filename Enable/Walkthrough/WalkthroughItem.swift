//
//  OnboardingItem.swift
//  Enable
//
//  Created by maxsinclair1 on 13/7/2022.
//

import Foundation

// Determines the content of a single page of the walkthrough, passing through plist data.

struct WalkthroughItem: Codable, Identifiable {
    var id = UUID()
    var title: String?
    var content: String?
    var sfSymbol: String?
    var selectedImage: String?
    
    enum CodingKeys: String, CodingKey {
        case title, content, sfSymbol, selectedImage
    }
    
    init(title: String? = nil,
         content: String? = nil,
         sfSymbol: String? = nil,
         selectedImage: String? = nil) {
        
        self.title = title
        self.content = content
        self.sfSymbol = sfSymbol
        self.selectedImage = selectedImage
        
    }
    
    init(from decoder: Decoder) throws {
        
        do {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decode(String?.self, forKey: .title)
            self.content = try container.decode(String?.self, forKey: .content)
            self.sfSymbol = try container.decode(String?.self, forKey: .sfSymbol)
            self.selectedImage = try container.decode(String?.self, forKey: .selectedImage)
            
        } catch {
            print(error)
        }
    }
    
}
