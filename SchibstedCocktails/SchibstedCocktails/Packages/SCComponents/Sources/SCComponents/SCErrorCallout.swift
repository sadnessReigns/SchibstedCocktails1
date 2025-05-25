//
//  SCError.swift
//  SCComponents
//
//  Created by Uladzislau Makei on 25.05.25.
//

import SwiftUI

public struct SCErrorCallout: View {

    @State private var animateBounce = false

    private let feedbackGenerator: UIImpactFeedbackGenerator?

    private let text: String

    public init(
        impact: UIImpactFeedbackGenerator.FeedbackStyle? = nil,
        text: String
    ) {
        self.text = text

        if let impact {
            feedbackGenerator = .init(style: impact)
            feedbackGenerator?.prepare()
        } else {
            feedbackGenerator = nil
        }
    }

    public var body: some View {
        ZStack {
            Text(text)
                .font(.caption)
                .dynamicTypeSize(.xSmall ... .xLarge)
                .foregroundColor(.red)
                .padding()
                .offset(x: animateBounce ? 0 : 12)
                .animation(
                    Animation.easeInOut(duration: 0.1)
                        .repeatCount(5, autoreverses: true),
                    value: animateBounce
                )
                .onAppear { [weak feedbackGenerator] in
                    animateBounce = false

                    DispatchQueue.main.async {
                        animateBounce = true
                        feedbackGenerator?.impactOccurred()
                        feedbackGenerator?.prepare()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            feedbackGenerator?.impactOccurred()
                            feedbackGenerator?.prepare()
                        }

                    }
                }
                .onDisappear {
                    animateBounce = false
                }
                .accessibilityElement()
                .accessibilityLabel(text)
                .accessibilityHint(text)
                .accessibilityAddTraits(.isStaticText)
        }

    }
}
