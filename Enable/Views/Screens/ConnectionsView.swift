//
//  ConnectionsView.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import SwiftUI
import Firebase

struct RecentMessageModel: Identifiable, Hashable {
    
    var id: String { documentId }
    
    let documentId: String
    let text: String
    let timestamp: Firebase.Timestamp
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

// This view presents the user with the opportunity to see each user in the database and chat with them real time by adding them as a new message or finding their profile picture on the top bar.

struct ConnectionsView: View {
    
    // MARK: PROPERTIES
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @ObservedObject var connections = ConnectionArrayObject()
    
    @State var selectedConnection: ConnectionModel?
    
    @State var searchText = ""
    
    @State var showAddMenu: Bool = false
    
    @State var shouldNavigateToChatLogView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // MARK: HEADER
                VStack(spacing: 18) {
                    
                    // MARK: SCROLLING CONTACTS
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack(spacing: 18) {
                            
                            Button(action: {
                                showAddMenu.toggle()
                            }, label: {
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.MyTheme.redColor)
                                    .padding(25)
                            })
                            .background(Color.MyTheme.beigeColor.opacity(1))
                            .clipShape(Circle())
                            // If the add menu state is toggled, the addconnection view will pop up for the user from the variable selectedConnection
                            .fullScreenCover(isPresented: $showAddMenu) {
                                AddConnection(didSelectNewUser: { user in
                                    self.shouldNavigateToChatLogView.toggle()
                                    self.selectedConnection = user
                                })
                            }
                            // Presents a horizontal scrolling list of each users image which can be pressed to show their chat
                            ForEach(connections.dataArray, id: \.self){ x in
                                Button(action: {
                                    self.selectedConnection = x
                                    self.shouldNavigateToChatLogView.toggle()
                                }, label: {
                                    
                                    Image(uiImage: x.profileImage)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .cornerRadius(60)
                                        .foregroundColor(Color.MyTheme.greyColor)
                                })
                                .frame(width: 75, height: 75, alignment: .center)
                                .background(Color.MyTheme.beigeColor.opacity(1))
                                .clipShape(Circle())
                            }
                            
                        }
                    })
                    
                    
                    SearchBar(text: $searchText)
                        .accentColor(.white)
                    
                }
                .padding()
                .background(Color.MyTheme.redColor)
                
                
                // MARK: MY CHATS AREA - MAIN BODY
                
                Spacer(minLength: 16)
                
                ScrollView{
                    ForEach(connections.dataArray.filter({"\($0)".contains(searchText) || searchText.isEmpty}), id: \.self) { user in
                        
                        
                        Button {
                            self.selectedConnection = user
                            self.shouldNavigateToChatLogView.toggle()
                        } label: {
                            VStack {
                                HStack(spacing: 16) {
                                    
                                    Image(uiImage: user.profileImage)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .font(.system(size: 32))
                                        .frame(width: 55, height: 55)
                                        .cornerRadius(44)
                                        .shadow(radius: 10)
                                        .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                        )
                                    
                                    VStack(alignment: .leading) {
                                        Text(user.displayName)
                                            .font(.system(size: 16, weight: .bold))
                                        // The user's bio is presented under their name to show their role as a trainer/clinician
                                        Text(user.bio == "" ? "This user has no bio!" : "Bio: \(user.bio)")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                }
                                Divider()
                                    .padding(.vertical, 8)
                            }
                            
                            
                            
                            
                        }
                        .padding(.horizontal)
                        
                    }
                }
                .padding(.bottom, 50)
                .foregroundColor(.primary)
                
                
                
                // MARK: CHATLOG
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatView(chatUser: self.selectedConnection)
                }

                
                
                
            }
            .navigationBarTitle("Connections")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(newMessageButton, alignment: .bottom)
            .padding(.bottom, 20)
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
        
    }
    
    private var newMessageButton: some View { // Refactoring code for easy reading
        Button {
            showAddMenu.toggle()
        } label: {
            HStack {
                Spacer()
                Text("New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.MyTheme.redColor)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
            
        }
        .fullScreenCover(isPresented: $showAddMenu) {
            AddConnection(didSelectNewUser: { user in
                self.selectedConnection = user
                self.shouldNavigateToChatLogView.toggle()

            })
        }
    }
    
    
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
        
    }
}
