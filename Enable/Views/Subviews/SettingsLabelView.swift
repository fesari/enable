//
//  SettingsLabelView.swift
//  Enable
//
//  Created by Max Sinclair on 5/1/22.
//

import SwiftUI

// This view is a simple view which is refactored in order to simplify the code in SettingsView, for which there are many options which must use this view styling. More specifically each title for each settings group box will use this label styling.

struct SettingsLabelView: View {
    
    // MARK: PROPERTIES.
    var labelText: String
    var labelImage: String
    
    var body: some View {
        VStack {
            HStack {
                Text(labelText)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: labelImage)
            }
            
            Divider()
                .padding(.vertical,4)
        }
    }
}

struct SettingsLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLabelView(labelText: "Test Label", labelImage: "heart")
            .previewLayout(.sizeThatFits)
    }
}
