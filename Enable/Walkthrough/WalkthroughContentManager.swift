//
//  WalkthroughContentManager.swift
//  Enable
//
//  Created by maxsinclair1 on 13/7/2022.
//

import Foundation

protocol WalkthroughContentManager {
    var limit: Int { get }
    var items: [WalkthroughItem] { get }
    init(manager: PlistManager)
}

final class WalkthroughContentManagerImpl: WalkthroughContentManager { // Convert plist into an array of walkthrough items
    
    var limit: Int {
        items.count - 1
    }
    
    var items: [WalkthroughItem]
    
    init(manager: PlistManager) {
        self.items = manager.convert(plist: "WalkthroughContent")
    }
}


