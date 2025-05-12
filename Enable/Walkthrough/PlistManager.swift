//
//  PlistManager.swift
//  Enable
//
//  Created by maxsinclair1 on 13/7/2022.
//

import Foundation

protocol PlistManager {
    func convert(plist fileName: String) -> [WalkthroughItem]
}

struct PlistManagerImpl: PlistManager {
    
    func convert(plist fileName: String) -> [WalkthroughItem] {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist"),
              let data = try? Data(contentsOf: url), // turn the url into a data item
              let items = try? PropertyListDecoder().decode([WalkthroughItem].self, from: data) else { // DECODE OUR DATA INTO AN ARRAY, hence the struct WalkthroughItem conforming to Codable
            return []
        }
        
        return items
    }
}
