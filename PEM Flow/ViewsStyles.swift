//
//  ViewsStyles.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 04/09/2022.
//

import SwiftUI

struct NumberTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.largeTitle, design: .rounded, weight: .semibold))
            .frame(width: 42)
    }
}

struct DescriptionTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(Font.TextStyle.subheadline, design: .rounded))
            .foregroundColor(.secondary)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            
    }
}

struct DataElementTitleTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(Font.TextStyle.headline, design: .rounded))
            .fixedSize(horizontal: false, vertical: false)
    }
}

struct ColoredIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            configuration.icon
                .foregroundStyle(.white, .purple.gradient)
                .font(.system(size: 20))
            configuration.title
                .fontWeight(.semibold)
        }
    }
}
struct ViewsStyles: View {
    var body: some View {
        VStack {
            Label("Physical Activity", systemImage: "figure.walk.circle.fill")
                .labelStyle(ColoredIconLabelStyle())
            Text("Set your mind free before bed by writing how do you feel? What happened special (or not) today? Being grateful for the good moments also help recovering.")
                .modifier(DescriptionTextStyle())
        }
    }
}

struct ViewsStyles_Previews: PreviewProvider {
    static var previews: some View {
        ViewsStyles()
    }
}
