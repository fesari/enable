//
//  EnableApp.swift
//  Enable
//
//  Created by Max Sinclair on 29/12/21.
//

import SwiftUI
import FirebaseCore
// import GoogleSignIn

@main
struct EnableApp: App {
    // connecting app delegate to the application
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Configuring the firebase connection
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
    
    // Implementing googleisgninflow
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      // return GIDSignIn.sharedInstance.handle(url)
          return false
    }
}
