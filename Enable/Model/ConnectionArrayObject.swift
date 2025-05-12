//
//  ConnectionArrayObjecg.swift
//  Enable
//
//  Created by Max Sinclair on 6/1/22.
//

import Foundation
import SwiftUI

class ConnectionArrayObject: ObservableObject {
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @State var downloadedImage: UIImage = UIImage(named: "logo.default")!
    
    @Published var dataArray = [ConnectionModel]()
    
    func fetchAllUsers() {
        
        AuthService.instance.downloadUserData { users in
            for eachUser in users {
                if eachUser.userID == self.currentUserID {

                } else {
                    let userID = eachUser.userID
                    let displayName = eachUser.displayName
                    let bio = eachUser.bio
                    
                    self.downloadImageForUser(forUserID: userID) { image in
                        
                        let conn = ConnectionModel(userID: userID, displayName: displayName, profileImage: image, bio: bio)
                        
                        self.dataArray.append(conn)
                        print(self.dataArray)
                    }
                    
                    
                }
            }
        }
        
    }
    
    private func downloadImageForUser(forUserID userID: String, handler: @escaping (_ image: UIImage) -> ()) {
        ImageManager.instance.downloadProfileImage(userID: userID) { image in
            if let returnedImage = image {
                print("RETURNEDIMAGE-> \(returnedImage)")
                handler(returnedImage)
            } else { handler(self.downloadedImage) }
            
        }
        
    }
    
    init() {
        
        
        fetchAllUsers()
        
        
    }
    
}
