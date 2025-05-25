//
//  SCProgressiveColorText.swift
//  SCComponents
//
//  Created by Uladzislau Makei on 24.05.25.
//

import SwiftUI

public struct SCProgressiveColorText: View {
    let text: String
    let coloredCount: Int
    let coloredColor: Color
    let defaultColor: Color

    public init(text: String, coloredCount: Int, coloredColor: Color, defaultColor: Color) {
        self.text = text
        self.coloredCount = coloredCount
        self.coloredColor = coloredColor
        self.defaultColor = defaultColor
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .foregroundColor(index < coloredCount ? coloredColor : defaultColor)
                    .animation(.easeIn(duration: 0.2), value: coloredCount)
            }
        }
    }
}
