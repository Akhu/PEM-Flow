//
//  ButtonStyles.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 05/01/2023.
//

import SwiftUI


struct BlueButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.headline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .contentShape(Rectangle())
        .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
  }
}


struct ButtonStyles: View {
    var body: some View {
        List {
            Button {
                
            } label: {
                Label("Test", image: "circle.fill")
                .labelStyle(TitleAndIconLabelStyle())
            }
            .buttonStyle(BlueButtonStyle())
            

        }
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyles()
    }
}
