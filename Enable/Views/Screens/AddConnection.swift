//
//  AddConnection.swift
//  Enable
//
//  Created by Max Sinclair on 22/1/22.
//

import SwiftUI

struct AddConnection: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var connections = ConnectionArrayObject()
    
    // callback variable is used here to determine the user being selected, in order to open the chat view for the appropriate user.
    let didSelectNewUser: (ConnectionModel) -> ()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(connections.dataArray, id: \.self) { user in
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            Image(uiImage: user.profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 2)
                                
                                
                                )
                            Text(user.displayName)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                        
                        Divider()
                            .padding(.vertical, 8)
                    }

                    
                }.padding(.top, 8)
                
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color(.label))
                    }

                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
