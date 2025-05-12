//
//  ChatView.swift
//  Enable
//
//  Created by Max Sinclair on 10/1/22.
//

import SwiftUI

// This view displays the current chat log between two users per database data.

struct ChatView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    let chatUser: ConnectionModel?
    
    @State var showAlert: Bool = true
    
    // initialiser determines what user's messages are displayed based on the variables passed through from connection view.
    init(chatUser: ConnectionModel?) {
        self.chatUser = chatUser
        self.messages = .init(chatUser: chatUser)
    }
    
    @ObservedObject var messages: MessageArrayObject
    
    var body: some View {
        ZStack {
            messagesView
            
            Text(messages.errorMessage)
                .background(Color.MyTheme.redColor)
                .padding()
                .cornerRadius(10)
        }
        .navigationTitle(chatUser?.displayName ?? "Unknown User")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in // Scroll view reader allows the scroll view to scroll down to the recent message when it is sent.
                ForEach(messages.chatMessages, id: \.self) { message in
                    VStack { // This selection determines whether the user has sent the message in order to determine chat bubble styling.
                        if message.fromId == currentUserID {
                            HStack {
                                Spacer()
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.MyTheme.redColor)
                                .cornerRadius(8)
                            }
                        } else {
                            HStack {
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                }
                                .padding()
                                .background(colorScheme == .dark ? Color.white : Color.MyTheme.greyColor)
                                .cornerRadius(8)
                                Spacer()
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                
                HStack { Spacer() }
                    .id("Empty") // Setting the id of the bottom bar to a position which the scrollview will scroll to when a new message is sent.
                    .onReceive(messages.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                        }
                    }
            }
        }
        .background(colorScheme == .light ? Color(.init(white: 0.95, alpha: 1)) : Color(.init(white: 0.05, alpha: 1)))
        // pushing the chat bottom bar to the bottom of the view
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(colorScheme == .dark ? Color.black.ignoresSafeArea() : Color.white.ignoresSafeArea())
        }
        
        
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
           /* Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(colorScheme == .dark ? .white : .black) */
            
            TextField("Enter your message here...", text: $messages.chatText)
            
            Button {
                messages.handleText()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.MyTheme.redColor)
            .cornerRadius(8)

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(chatUser: .init(userID: "", displayName: "Max Sinclair", profileImage: UIImage(named: "logo.default")!, bio: ""))
        }
    }
}

// Custom Rounded Shapes

struct RoundedTopShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 35, height: 35))
        return Path(path.cgPath)
    }
}

struct RoundedBottomShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
        return Path(path.cgPath)
    }
}
