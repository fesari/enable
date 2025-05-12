//
//  SearchBar.swift
//  Enable
//
//  Created by Max Sinclair on 29/12/21.
//

import SwiftUI

// This SearchBar view has been refactored, as it is applied often to many different screens, and therefore makes sense to be contained within its own view.

struct SearchBar: View {
    
    // MARK: PROPERTIES
    
    // This binding property connects to a State property in LibraryView, allowing searched text to be passed through here.
    @Binding var text: String
    
    // Check whether the search bar is being used.
    @State private var isEditing: Bool = false
    
    
    var body: some View {
        
        
        HStack {
            TextField("Search here...", text: $text)
                .padding(15)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .foregroundColor(Color.primary)
                .overlay( // Creating the style for the search bar + logic to check when a search clear button is included
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                        
                        // Here, if the user has pressed on the search bar, we provide the option to clear the current search by revealing a button on the right side of the search bar.
                        if isEditing {
                            Button(action: { self.text = "" },
                                   label:  { Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                           }
                                  )
                        }
                        
                    }
                    
                    
                ).onTapGesture { self.isEditing = true }
            
            if isEditing { Button(action: { // Creating a cancel button which closes the search bar even with existing content.
                           self.isEditing = false
                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                           }) { Text("Cancel") } // Label from trailing closure.
                .padding(.trailing,10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        
    }
}


