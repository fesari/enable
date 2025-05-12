//
//  TextFieldWithBottomLine.swift
//  Enable
//
//  Created by Max Sinclair on 2/1/22.
//

import SwiftUI
// Together with the horizontal line view, we combine a text field to form a custom text field type.

struct TextFieldWithBottomLine: View {
    
    // MARK: PROPERTIES
    @State var text: String = ""
    private var placeholder = ""
    private let lineThickness = CGFloat(2.0)

    init(placeholder: String) {
        self.placeholder = placeholder
    }

    var body: some View {
        VStack {
            // The placeholder text is set to empty so that it can be changed in its parent view
         TextField(placeholder, text: $text)
            HorizontalLine(color: Color.MyTheme.redColor)
        }.padding(.bottom, lineThickness)
    }
}

struct TextFieldWithBottomLine_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithBottomLine(placeholder: "My placeholder")
            .previewLayout(.sizeThatFits)
    }
}
