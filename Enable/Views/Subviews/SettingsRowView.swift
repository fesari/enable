//
//  SettingsRowView.swift
//  Enable
//
//  Created by Max Sinclair on 5/1/22.
//

import SwiftUI

// This view defines the styling for a single option within the GroupBox of a settings view, and is created in order to simplify the need for repetitive code.

struct SettingsRowView: View {
    
    // MARK: PROPERTIES
    // Values passed in by the initial SettingsView
    var leftIcon: String
    var text: String
    var color: Color
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: leftIcon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(leftIcon: "heart.fill", text: "Row Title", color: .red)
            .previewLayout(.sizeThatFits)
    }
}
