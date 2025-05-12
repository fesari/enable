//
//  CreateView.swift
//  Enable
//
//  Created by Max Sinclair on 3/1/22.
//

import SwiftUI

// View presenting the initial option to create either an exercise or routine.

struct CreateView: View {
    @State var exercisePressed: Bool = false
    @State var routinePressed: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    NavigationLink(destination: CreateExerciseView(),
                                   label: {
                        Text("CREATE EXERCISE")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.MyTheme.greyColor)
                    .navigationBarTitleDisplayMode(.inline)
                    
                    Spacer()
                    
                    
                    NavigationLink(destination: CreateRoutineView(),
                                   label: {
                        Text("CREATE ROUTINE")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.MyTheme.redColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color.white)
                    .navigationBarTitleDisplayMode(.inline)
                    
                    
                }
                
                Image("logo.normal.transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .shadow(radius: 12)
            }
            .edgesIgnoringSafeArea(.top)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
