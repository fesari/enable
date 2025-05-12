//
//  AuthService.swift
//  Enable
//
//  Created by maxsinclair1 on 20/2/2022.
//

// Used to authenticate users in Firebase
// Used to handle user accounts in Firebase
import Foundation
import FirebaseAuth
import FirebaseFirestore // DB

// Link the project to firestore
let DB_BASE = Firestore.firestore() // GLOBAL VARIABLES

class AuthService {
    
    // MARK: PROPERTIES
    
    // Create an instance of this class to be later reference in other files
    static let instance = AuthService()
    
    private var REF_USERS = DB_BASE.collection("users")
    
    
    // MARK: AUTH USER FUNCTIONS
    
    
    // logs the user into firebase using credentials receiving from logging in via a provider (apple or google)
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String?) -> ()) {
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            // check for errors
            if error != nil {
                print("Error logging into Firebase.")
                handler(nil, true, nil, nil)
                return
            }
            
            // check for provider ID
            guard let providerID = result?.user.uid else {
                print("Error getting provider ID.")
                handler(nil, true, nil, nil)
                return
            }
            
            
            // check if the user exists already
            self.checkIfUserExistsInDatabase(providerID: providerID) { (returnedUserID) in
                
                if let userID = returnedUserID {
                    // user exists, log in to app immediately
                    handler(providerID, false, false, userID)
                } else {
                    // user does not exist, continue onboarding process
                    handler(providerID, false, true, nil)
                }
            }
            
            
        }
    }
    
    // after authenticating the user and logging them into firebase, we must log the user into the app itself
    func logInUserToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        // Get the user's info
        getUserInfo(forUserID: userID) { (returnedName, returnedBio) in
            if let name = returnedName, let bio = returnedBio {
                // Success
                print("Success getting user info while logging in")
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Set the user's info into our app
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
                }
                
            } else {
                
                // Error
                print("Error getting user info while logging in")
                handler(false)
            }
            
        }
    }
    
    // Log out of the app, removing persistant data in the process.
    func logOutUser(handler: @escaping (_ success: Bool) -> ()) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error \(error)")
            handler(false)
            return
        }
        
        handler(true)
        
        // Update UserDefaults - persisting data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            UserDefaults.standard.removeObject(forKey: CurrentUserDefaults.userID)
            UserDefaults.standard.removeObject(forKey: CurrentUserDefaults.bio)
            UserDefaults.standard.removeObject(forKey: CurrentUserDefaults.displayName)
            
        }
        
    }
    
    // create a new user in the users document in firebase firestore
    func createNewUserInDatabase(name: String, email: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) -> ()) {
        
        // Set up a user Document within the user Collection
        
        let document = REF_USERS.document()
        let userID = document.documentID
        
        // Upload profile image to Storage
        ImageManager.instance.uploadProfileImage(userID: userID, image: profileImage)
        
        // Upload profile data to Firestore
        let userData: [String: Any] =  [
            
            DatabaseUserField.displayName : name,
            DatabaseUserField.email : email,
            DatabaseUserField.providerID : providerID,
            DatabaseUserField.provider : provider,
            DatabaseUserField.userID : userID,
            DatabaseUserField.bio : "",
            DatabaseUserField.dateCreated : FieldValue.serverTimestamp(),
            
        ]
        
        document.setData(userData) { (error) in
            
            if let error = error {
                // Error
                print("Error uploading data to user document. \(error)")
                handler(nil)
            } else {
                // Success
                handler(userID)
            }
        }
        
        
    }
    
    // function used in the login to DB function.
    private func checkIfUserExistsInDatabase(providerID: String, handler: @escaping(_ existingUserID: String?) -> ()) {
        // if a userID is returned, then a user exists in our database
        
        REF_USERS.whereField(DatabaseUserField.providerID, isEqualTo: providerID).getDocuments { (querySnapshot, error) in
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                // SUCCESS
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            } else {
                // ERROR, i.e NEW USER
                handler(nil)
                return
            }
        }
        
        
    }
    
    //MARK: DELETION FUNCTIONS
    
    // Deleting acc from auth firebase
    
    func deleteAccountFromAuth() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error = error {
                // An error happened.
                print(error)
            } else {
                // Account deleted.
                print("Successfully deleted user \(user)")
            }
        }
        
        
        
    }
    
    // Used as part of the delete acc flow
    func deleteUserDocumentData(forUserID userID: String) {
        
        let query = REF_USERS.whereField(DatabaseExerciseField.userID, isEqualTo: userID)
        
        query.getDocuments() { querySnapshot, error in
            if error != nil {
                
                print("Error getting documents for userID \(userID)")
                
                
            } else {
                
                for eachDocument in querySnapshot!.documents {
                    self.REF_USERS.document("\(eachDocument.documentID)").delete()
                }
                
            }
        }
        
        print("Successfully deleted all user data for userID \(userID)")
        
    }
    
    
    
    // MARK: GET USER FUNCTIONS
    
    // Get the information for a user in the DB from the firestore document
    
    func getUserInfo(forUserID userID: String, handler: @escaping (_ name: String?, _ bio: String?) -> ()) {
        
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            
            if let document = documentSnapshot,
               let name = document.get(DatabaseUserField.displayName) as? String,
               let bio = document.get(DatabaseUserField.bio) as? String {
                // Success
                print("Success getting user info")
                handler(name, bio)
                return
                
            } else {
                // Error
                print("Error getting user info")
                handler(nil, nil)
                return
            }
            
        }
    }
    
    // MARK: GETTERS FOR CONNECTION RELATED ACTIVITIES
    
    // get all user data for all users in firestore
    func downloadUserData(handler: @escaping (_ users: [(userID: String, displayName: String, bio: String)]) -> ()) {
        
        REF_USERS.getDocuments { querySnapshot, error in
            handler(self.getUserFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    // a snapshot is a query from the database, here we are turning this snapshot data into the data types applicable for the application
    private func getUserFromSnapshot(querySnapshot: QuerySnapshot?) -> [(userID: String, displayName: String, bio: String)] {
        
        var connectionArray = [(String, String, String)]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                if
                    let userID =
                        document.get(DatabaseUserField.userID) as? String,
                    let displayName =
                        document.get(DatabaseUserField.displayName) as? String,
                    let bio =
                        document.get(DatabaseUserField.bio) as? String {
                    
                        let newConnection = (userID, displayName, bio)
                        connectionArray.append(newConnection)
                }
            }
            return connectionArray
        } else {
            print("No documents in snapshot found")
            return connectionArray
        }
    }
    
    
    // MARK: DOCUMENT GETTERS FROM FIREBASE
    
    // get the document of a single user in firestore - used for the connections screen
    func getUserDocumentForUser(forUserID userID: String, handler: @escaping (_ returnedUserDocument: String) -> ()) {
        
        var returnedDocument: String = ""
        
        let query = REF_USERS.whereField(DatabaseExerciseField.userID, isEqualTo: userID)
        
        query.getDocuments() { querySnapshot, error in
            if error != nil {
                
                print("Error getting document for userID \(userID)")
                
                handler(returnedDocument)
                
            } else {
                
                for singleDocument in querySnapshot!.documents {
                    
                    returnedDocument = singleDocument.documentID
                    
                }
                
                handler(returnedDocument)
                
            }
        }
        
    }
    
    // MARK: UPDATE USER FUNCTIONS
    
    // used for the settings update user name menu
    func updateUserDisplayName(userID: String, displayName: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String: Any] = [
            DatabaseUserField.displayName : displayName
        ]
        
        REF_USERS.document(userID).updateData(data) { error in
            if let error = error {
                print("Error updating user display name. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
    }
    
    // settings menu - update bio
    func updateUserBio(userID: String, bio: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String: Any] = [
            DatabaseUserField.bio : bio
        ]
        
        REF_USERS.document(userID).updateData(data) { error in
            if let error = error {
                print("Error updating user bio. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
    }
    
}
