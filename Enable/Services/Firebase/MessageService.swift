//
//  MessageService.swift
//  Enable
//
//  Created by maxsinclair1 on 16/7/2022.
//


import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

// This file will be used to host all of the functions related to messaging, and the transferring of message data from the database to the application.
class MessageService {
    
    // MARK: PROPERTIES
    // Create an instance of the class to be later referenced in other files in the application
    static let instance = MessageService()
    
    // Creating new collection references in firestore
    private var REF_MESSAGES = DB_BASE.collection("messages")
    private var REF_RECENT_MESSAGES = DB_BASE.collection("recent_messages")
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    // MARK: CREATE FUNCTIONS
    
    // Save a message to the database
    func saveMessageDocument(fromId: String, toId: String, text: String, handler: @escaping (_ error: String?) -> ()) {
        
        // Telling the function where in the database the document will be saved.
        let senderDocument = REF_MESSAGES.document(fromId).collection(toId).document()
        
        let messageData = [DatabaseMessageField.fromId: fromId, DatabaseMessageField.toId: toId, DatabaseMessageField.text: text, DatabaseMessageField.timestamp: Timestamp()] as [String: Any]
        
        senderDocument.setData(messageData) { error in
            if let error = error {
                print("Failed saving message to Firestore: \(error)")
                handler("Failed saving message to Firestore")
            } else {
                print("Successfully saved message document for sender to Firestore")
            }
        }
        
        // Create a document for the recipient of the message as well
        let recipientDocument = REF_MESSAGES.document(toId).collection(fromId).document()
        
        recipientDocument.setData(messageData) { error in
            if let error = error {
                print("Failed saving message to Firestore: \(error)")
                handler("Failed saving message to Firestore")
            } else {
                print("Successfully saved message document for recipient to Firestore")
            }
        }
        
    }
    
    // Create a reference in the database to the most recent message
    func createRecentMessagesDocument(userID: String, toId: String, chatText: String, chatUser: ConnectionModel?, handler: @escaping (_ error: String?) -> ()) {
        
        guard let chatUser = chatUser else { return }

        let document = REF_RECENT_MESSAGES.document(userID).collection("messages").document(toId)
        
        let data = [
            DatabaseMessageField.timestamp: Timestamp(),
            DatabaseMessageField.text: chatText,
            DatabaseMessageField.fromId: userID,
            DatabaseMessageField.toId: toId,
            DatabaseUserField.displayName: chatUser.displayName as Any
        ] as [String: Any]
        
        document.setData(data) { error in
            if let error = error {
                let errorMessage = "Failed to save recent message with error: \(error)"
                print(error)
                handler(errorMessage)
            } else {
                print("Successfully uploaded recent message to Firestore")
            }
        }
        
        let recipientData = [
            DatabaseMessageField.timestamp: Timestamp(),
            DatabaseMessageField.text: chatText,
            DatabaseMessageField.fromId: userID,
            DatabaseMessageField.toId: toId,
            DatabaseUserField.displayName: chatUser.displayName as Any
        ]
        
        let recipientDocument = REF_RECENT_MESSAGES.document(toId).collection("messages").document(userID)
        
        recipientDocument.setData(recipientData) { error in
            if let error = error {
                let errorMessage = "Failed to save recent message with error: \(error)"
                print(error)
                handler(errorMessage)
            } else {
                print("Successfully uploaded recent message for recipient to Firestore")
            }
        }
        
    }
    
    // MARK: GET FUNCTIONS
    
    // Download all of the messages data
    func downloadMessagesData(chatUser: ConnectionModel?, handler: @escaping (_ messages: [MessageModel]) -> ()) {
        guard let fromId = currentUserID else { return }
        guard let toId = chatUser?.userID else { return }
        
        // We add a listener here instead of running a query to ensure new messages automatically update
        REF_MESSAGES.document(fromId).collection(toId).order(by: DatabaseMessageField.timestamp).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting message data from snapshot listener with error: \(error)")
            }
            
            handler(self.getMessagesFromSnapshot(querySnapshot: querySnapshot))
            
        }
    }
    
    // Transform the query data into usable data in the application
    private func getMessagesFromSnapshot(querySnapshot: QuerySnapshot?) -> [MessageModel] {
        
        var messageArray = [MessageModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                if
                    let fromId = document.get(DatabaseMessageField.fromId) as? String,
                    let toId = document.get(DatabaseMessageField.toId) as? String,
                    let text = document.get(DatabaseMessageField.text) as? String {
                    
                    let docId = document.documentID
                        
                    let newMessage = MessageModel(documentId: docId, fromId: fromId, toId: toId, text: text)
                    messageArray.append(newMessage)
                    
                    
                }
                    
            }
            print("\(messageArray)")
            print("RETURNING MESSAGE ARRAY")
            return messageArray
            
        } else {
            print("No documents in snapshot found")
            return messageArray
        }
    }
    
    // MARK: RECENT MESSAGES FUNCTIONS -- NO LONGER USING
    
    
    // Download the data of a recent message between two users
    func downloadRecentMessagesData(handler: @escaping (_ recentMessages: [RecentMessageModel]) -> ()) {
        guard let userID = currentUserID else { return }
        
        // Adding a listener for new messages
        REF_RECENT_MESSAGES.document(userID).collection("messages").order(by: DatabaseMessageField.timestamp).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error receiving recent message data from snapshot listener with error: \(error)")
            } else {
                handler(self.getRecentMessagesFromSnapshot(querySnapshot: querySnapshot))
            }
        }
    }
    
    // Reload the recent messages
    private func getRecentMessagesFromSnapshot(querySnapshot: QuerySnapshot?) -> [RecentMessageModel] {
        var recentMessageArray = [RecentMessageModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                if
                    let text = document.get(DatabaseMessageField.text) as? String {
                    
                    let docId = document.documentID
                    let timestamp = Timestamp()
                    
                    let newRecentMessage = RecentMessageModel(documentId: docId, text: text, timestamp: timestamp)
                    recentMessageArray.append(newRecentMessage)
                }
                    
            }
            return recentMessageArray
        } else {
            print("No documents in snapshot found")
            return recentMessageArray
        }
    }
    
}


