//
//  Extensions.swift
//  Enable
//
//  Created by Max Sinclair on 29/12/21.
//

import Foundation
import SwiftUI

extension Color {
    
    
    struct MyTheme {
        
        static var redColor: Color {
            return Color("ColorRed")
        }
        
        static var greyColor: Color {
            return Color("ColorGrey")
        }
        
        static var whiteColor: Color {
            return Color("ColorWhite")
        }
        
        static var beigeColor: Color {
            return Color("ColorBeige")
        }
        
    }
}

extension View {
    
    func getRootViewController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
}
