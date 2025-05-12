//
//  ImageManager.swift
//  Enable
//
//  Created by maxsinclair1 on 12/3/2022.
//

import Foundation
import FirebaseStorage // Holds images and videos
import UIKit

// Images saved in cache so that the screens do not need to reload every time with the same image data
let imageCache = NSCache<AnyObject, UIImage>()

class ImageManager {
    
    // MARK: PROPERTIES
    
    // create an instance of the class to be referenced by other files
    static let instance = ImageManager()
    
    // create a storage reference
    private var REF_STOR = Storage.storage()
    
    
    
    // MARK: PUBLIC FUNCTIONS
    // Functions we call from other places in the app
    
    // Upload a profile picture image to Firebase Storage
    func uploadProfileImage(userID: String, image: UIImage) {
        
        // Get the path where we will save the image
        let path = getProfileImagePath(userID: userID)
        
        
        // Save image to path
        DispatchQueue.global(qos: .userInteractive).async { // MULTI THREADING UPLOAD PROCESSES TO IMPROVE PERFORMANCE
            self.uploadImage(path: path, image: image) { (_) in } // Note: handler not required
        }
        
        // Clear cache to force the next download to pull if the user has changed their profile picture
        imageCache.removeObject(forKey: path)
        
    }
    
    // Upload a exercise picture image to Firebase Storage
    func uploadExerciseImage(exerciseID: String, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        // Get the path where we will save the image
        let path = getExerciseImagePath(exerciseID: exerciseID)
        
        // Save image to path
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { (success) in
                DispatchQueue.main.async {
                    handler(success)
                }
            }
        }
        
        
        
    }
    // Upload a routine image to Firebase Storage
    func uploadRoutineImage(routineID: String, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        // Get the path to save image
        let path = getRoutineImagePath(routineID: routineID)
        
        // Save image to path
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { success in
                DispatchQueue.main.async {
                    handler(success)
                }
            }
        }
    }
    // Get a profile image from storage
    func downloadProfileImage(userID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        // Get the path where the image is saved
        let path = getProfileImagePath(userID: userID)
        
        // Download the image from path
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { (returnedImage) in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }
    
    //  downloading the exercise image from storage
    func downloadExerciseImage(exerciseID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        // Get the path where the image is saved
        let path = getExerciseImagePath(exerciseID: exerciseID)
        
        // Download image from the path
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { (returnedImage) in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }
    
    // download a routine image from storage
    func downloadRoutineImage(routineID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        // Get the path where the image is saved
        let path = getRoutineImagePath(routineID: routineID)
        
        // Download image from the path
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { returnedImage in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
        
        
    }
    
    // delete the reference to an exercise image in storage
    func deleteExerciseImage(forUserID userID: String) {
        let storageRef = REF_STOR.reference()
        
        DataService.instance.getExerciseDocumentForUser(forUserID: userID) { returnedExerciseID in
            for exercise in returnedExerciseID {
                
                let exerciseRef = storageRef.child("exercises/\(exercise)/1")
                
                exerciseRef.delete { error in
                    
                    if let error = error {
                        print(error)
                    }
                
                }
            }
            
            print("Successfully deleted all exercise images for userID \(userID)")
                    
        }
    }
    
    //MARK: IMAGE DELETION FUNCTIONS
   // delete a profile picture image by removing its reference from storage
    func deleteProfileImage(forUserID userID: String) {
        let storageRef = REF_STOR.reference()
        
        AuthService.instance.getUserDocumentForUser(forUserID: userID) { returnedUserDocument in
            let userRef = storageRef.child("users/\(returnedUserDocument)/profile")
            
            userRef.delete { error in
                if let error = error {
                    print(error)
                } else {
                    print("Successfully deleted user image for userID \(userID)")
                }
            }
        }
        
    }
    
    // MARK: PRIVATE FUNCTIONS
    // Functions we call from this file only
    // get the path in firebase in storage for a profile image
    private func getProfileImagePath(userID: String) -> StorageReference {
        
        let userPath = "users/\(userID)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        return storagePath
    }
    
    // get the path in firebase in storage for an exercise image
    private func getExerciseImagePath(exerciseID: String) -> StorageReference {
        let exercisePath = "exercises/\(exerciseID)/1"
        let storagePath = REF_STOR.reference(withPath: exercisePath)
        return storagePath
    }
    
    // get the path in firebase in storage for a routine image
    private func getRoutineImagePath(routineID: String) -> StorageReference {
        let routinePath = "routines/\(routineID)/1"
        let storagePath = REF_STOR.reference(withPath: routinePath)
        return storagePath
    }
    
    // upload an image to firebase storage
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        
        var compression: CGFloat = 1.0 // For each repeat of while loop, compress by 0.05 of total pixel size
        let maxFileSize: Int = 240 * 240 // Maximum file size that we want to save
        let maxCompression: CGFloat = 0.05 // Maximum compression we ever allow
        
        // Get image data
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // Check maximum file size
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
            print(compression)
        }
        
        // Get image data
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // Get photo metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Save data to path
        path.putData(finalData, metadata: metadata) { (_, error) in
            if let error = error {
                // Error
                print("Error uploading image. \(error)")
                handler(false)
                return
            } else {
                // Success
                print("Success uploading image")
                handler(true)
                return
            }
        }
        
    }
    
    private func downloadImage(path: StorageReference, handler: @escaping (_ image: UIImage?) -> ()) {
        
        if let cachedImage = imageCache.object(forKey: path) {
            print("Image found in cache")
            handler(cachedImage)
            return
        } else {
            path.getData(maxSize: 27 * 1024 * 1024) { (returnedImageData, error) in
                
                if let data = returnedImageData, let image = UIImage(data: data) {
                    // Success getting image data
                    imageCache.setObject(image, forKey: path)
                    handler(image)
                    return
                } else {
                    // Error getting image data
                    print("Error getting data from path for image")
                    handler(nil)
                    return
                }
            }
        }

    }
    
    
    
}
