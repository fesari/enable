//
//  WalkthroughView.swift
//  Enable
//
//  Created by maxsinclair1 on 13/7/2022.
//

import SwiftUI

typealias WalkthroughGetStartedAction = () -> Void

// Styling the content of the walkthrough view itself.

struct WalkthroughView: View {
    @Environment(\.presentationMode) var presentationMode
    let item: WalkthroughItem
    
    let limit: Int
    let handler: WalkthroughGetStartedAction
    @Binding var index: Int
    
    internal init(item: WalkthroughItem,
                  limit: Int,
                  index: Binding<Int>,
                  handler: @escaping WalkthroughGetStartedAction) {
        self.item = item
        self.limit = limit
        self._index = index // get the value of the binding variable
        self.handler = handler
    }
    
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(item.selectedImage ?? "logo.default")
                .resizable()
                .scaledToFit()
                .padding(.bottom, 50)
                //.font(.system(size: 120, weight: .bold))
            
            Text(item.title ?? "")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom, 2)
                .foregroundColor(.primary) // Altered
            
            Text(item.content ?? "")
                .font(.system(size: 12, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .foregroundColor(Color.MyTheme.redColor) // Altered
            
            Button {
                presentationMode.wrappedValue.dismiss()
                handler()
            } label: {
                Text("Get Started")
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color.MyTheme.redColor)
            .clipShape(Capsule())
            .padding(.top, 50)
            .opacity(index == limit ? 1 : 0)
            .allowsHitTesting(index == limit)
            .animation(.easeInOut(duration: 0.25))

            
            
            
        }
        .padding(.bottom, 150)
    }
}

struct WalkthroughView_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughView(item: WalkthroughItem(title: "Dummy", content: "Dummy Content", sfSymbol: "heart.fill", selectedImage: "view"), limit: 0,
                        index: .constant(0)) { }
    }
}
 
