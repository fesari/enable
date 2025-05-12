//
//  MessageArrayObject.swift
//  Enable
//
//  Created by Max Sinclair on 10/1/22.
//

import Foundation
import SwiftUI

class MessageArrayObject: ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [MessageModel]()
    @Published var recentMsgDataArray = [RecentMessageModel]()
    @Published var count = 0
    
    let chatUser: ConnectionModel?
    
    init(chatUser: ConnectionModel?) {
        self.chatUser = chatUser
        
        fetchMessages()
        
        //fetchRecentMessages()
    }
    
    func fetchMessages() {
        MessageService.instance.downloadMessagesData(chatUser: self.chatUser) { messages in
            self.chatMessages = messages
            print(messages)
            DispatchQueue.main.async {
                self.count += 1
            }
        }
        
        
    }
    
    func fetchRecentMessages() {
        MessageService.instance.downloadRecentMessagesData { recentMessages in
            self.recentMsgDataArray = recentMessages
            
            
                
        }
            
            
            
        
    }
    
    func handleText() {
        print(chatText)
        
        guard let fromId = currentUserID else { return }
        
        guard let toId = chatUser?.userID else { return }
        
        MessageService.instance.saveMessageDocument(fromId: fromId, toId: toId, text: self.chatText) { error in
            
            if let error = error {
                self.errorMessage = error
            }
            
        }
        
        //persistRecentMessage()
        
        self.chatText = ""
        self.count += 1
    }
    
    private func persistRecentMessage() {
        
        guard let userID = currentUserID else { return }
        
        guard let toId = chatUser?.userID else { return }
        
        MessageService.instance.createRecentMessagesDocument(userID: userID, toId: toId, chatText: self.chatText, chatUser: self.chatUser) { error in
            if let error = error {
                self.errorMessage = error
            }
        }
        
        
        
    }
    
    
}

