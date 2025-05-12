//
//  WalkthroughScreenView.swift
//  Enable
//
//  Created by maxsinclair1 on 13/7/2022.
//

import SwiftUI

struct WalkthroughScreenView: View {
    
    
    let manager: WalkthroughContentManager
    let handler: WalkthroughGetStartedAction
    
    @State private var selected = 0
    
    init(manager: WalkthroughContentManager,
                  handler: @escaping WalkthroughGetStartedAction) {
        self.manager = manager
        self.handler = handler
    }
    
    var body: some View {
        
        TabView(selection: $selected) {
            
            ForEach(manager.items.indices, id: \.self) { index in
                WalkthroughView(item: manager.items[index],
                                limit: manager.limit,
                                index: $selected,
                                handler: handler)
            }
            
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        
        
    }
}

struct WalkthroughScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughScreenView(manager: WalkthroughContentManagerImpl(manager: PlistManagerImpl())) {}
    }
}
