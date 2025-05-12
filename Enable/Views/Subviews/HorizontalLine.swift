//
//  HorizontalLine.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import SwiftUI

// This view is a custom shape definition, used in the styling of the create exercise and create routine subviews.

struct HorizontalLineShape: Shape {
    
    // Here we create the shape itsekf

    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}

struct HorizontalLine: View {
    
    // MARK: PROPERTIES
    private var color: Color? = nil
    private var height: CGFloat = 1.0

    init(color: Color, height: CGFloat = 1.0) {
        self.color = color
        self.height = height
    }
    
    // MARK: Shape creation
    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: 0, maxWidth: .infinity, minHeight: height, maxHeight: height)
    }
}

struct HorizontalLine_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalLine(color: .black)
            .previewLayout(.sizeThatFits)
    }
}
