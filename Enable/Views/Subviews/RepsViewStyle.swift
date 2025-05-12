//
//  RepsViewStyle.swift
//  Enable
//
//  Created by Max Sinclair on 3/1/22.
//

import SwiftUI

// This view is a custom view which allows the user to select the number of repetitions and sets to assign to an exercise in the creation process.

struct RepsViewStyle: View {
    
    // MARK: PROPERTIES
    @Binding var reps: String
    @Binding var sets: String
    
    var body: some View {
        VStack {
            
            // Title styling to explain to the user what is being selected here.
            HStack {
                Text("Select repetitions and sets: ")
                    .fontWeight(.semibold)
                    .padding([.top, .trailing])
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                
                Spacer()
                
                
                Picker(selection: $reps,
                       label: Text("\(reps)"),
                       content: {
                    // Here we validate the reps data by ensuring the max number of reps is set to 100.
                        ForEach(1..<100) { number in
                            if number == 1 {
                                Text("\(number) rep")
                                    .tag("\(number) rep")
                            } else {
                                Text("\(number) reps")
                                    .tag("\(number) reps")
                            }
                        }
                        
                       })
                    .pickerStyle(MenuPickerStyle())
                    .padding(12)
                    .padding(.horizontal, 20)
                    .background(Color.MyTheme.redColor)
                    .cornerRadius(10)
                    .accentColor(.primary)
                    .font(.headline)
                
                
                
                Picker(selection: $sets,
                       label: Text("\(sets)"),
                       content: {
                    // Similarly, we validate the sets data by ensuring the max number is 20. (Sets are generally performed in lesser quantities.)
                        ForEach(1..<20) { number in
                            if number == 1 {
                                Text("\(number) set")
                                    .tag("\(number) set")
                            } else {
                                Text("\(number) sets")
                                    .tag("\(number) sets")
                            }
                        }
                        
                       })
                    .pickerStyle(MenuPickerStyle())
                    .padding(12)
                    .padding(.horizontal, 20)
                    .background(Color.MyTheme.redColor)
                    .cornerRadius(10)
                    .accentColor(.primary)
                    .font(.headline)
                
                Spacer()
            }
            .padding()
        }
    }
}
