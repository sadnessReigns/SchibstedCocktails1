//
//  SpinningView.swift
//  SCComponents
//
//  Created by Uladzislau Makei on 25.05.25.
//

import SwiftUI

public struct SCSpinningView: View {
    @State private var isSpinning: Bool = false

    private let size: CGFloat

    public init(size: CGFloat = 32) {
        self.size = size
    }

    public var body: some View {
        Image(systemName: "arrow.2.circlepath")
            .font(.system(size: size))
            .rotationEffect(.degrees(isSpinning ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isSpinning)
            .onAppear { isSpinning = true }
            .onDisappear { isSpinning = false }
    }
}
