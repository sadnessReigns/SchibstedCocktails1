//
//  SCButton.swift
//  SCComponents
//
//  Created by Uladzislau Makei on 25.05.25.
//

import SwiftUI
import Combine

public struct SCButton<Label: View>: View {

    // MARK: - View State

    @State private var isLoading: Bool = false
    private let action: () -> Void
    private let label: () -> Label
    private let feedbackGenerator: UIImpactFeedbackGenerator?

    // MARK: - Init
    
    public init(
        impact: UIImpactFeedbackGenerator.FeedbackStyle? = nil,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.label = label

        if let impact {
            feedbackGenerator = .init(style: impact)
            feedbackGenerator?.prepare()
        } else {
            feedbackGenerator = nil
        }
    }

    public var body: some View {
        Button(
            action: {
                feedbackGenerator?.impactOccurred()
                feedbackGenerator?.prepare()
                action()
            }) {
                label()
                    .dynamicTypeSize(.medium ... .accessibility5)
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .accessibilityAddTraits(.isButton)
    }
}
