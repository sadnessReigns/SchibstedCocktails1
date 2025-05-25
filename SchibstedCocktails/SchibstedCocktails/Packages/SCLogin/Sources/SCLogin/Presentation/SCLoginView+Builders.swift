//
//  SCLoginView+Builders.swift
//  SCLogin
//
//  Created by Uladzislau Makei on 24.05.25.
//

import SwiftUI
import SCComponents

// MARK: - Subviews builders

internal extension SCLoginView {

    @ViewBuilder
    func logo() -> some View {
        Image("schibsted_logo", bundle: .module)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaledToFit()
            .ignoresSafeArea()
            .opacity(0.035)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    func usernameField() -> some View {
        SCOneLineTextField(
            text: $viewModel.username,
            strokeColor: focusedField == .username ? Color.accentColor : Color.gray
                .opacity(0.3),
            prompt: "e.g. schibsted"
        )
        .focused($focusedField, equals: .username)
        .submitLabel(.next)
        .onSubmit { setFocus(to: .password) }
        .accessibilityLabel("Username")
        .accessibilityHint("Enter your username")
    }

    @ViewBuilder
    func passwordField() -> some View {
        SCOneLineTextField(
            style: .secure,
            text: $viewModel.password,
            strokeColor: focusedField == .password ? Color.accentColor : Color.gray.opacity(0.3),
            prompt: "e.g. mojito"
        )
        .focused($focusedField, equals: .password)
        .submitLabel(.go)
        .onSubmit {
            Task { [weak viewModel] in
                await viewModel?.login()
            }
        }
        .accessibilityLabel("Password")
        .accessibilityHint("Enter your password securely")
    }

    @ViewBuilder
    func loginButton() -> some View {
        SCButton(
            impact: .soft,
            action: {
                Task { [weak viewModel] in
                    await viewModel?.login()
                }
            },
            label: {
                if viewModel.isLoading {
                    SCSpinningView(size: 34)
                        .tint(Color.white)
                } else {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                }

            })
        .background(
            viewModel.username.isEmpty || viewModel.password.isEmpty ? Color.secondary : Color.accentColor
        )
        .cornerRadius(10)
        .disabled(viewModel.username.isEmpty || viewModel.password.isEmpty)
        .accessibilityLabel("Login Button")
        .accessibilityHint("Tap to attempt login")
    }

    @ViewBuilder
    func ctaCallout() -> some View {
        SCProgressiveColorText(
            text: ctaText,
            coloredCount: (viewModel.username.count + viewModel.password.count) * 2,
            coloredColor: .blue,
            defaultColor: .primary.opacity(0.3)
        )
        .font(.largeTitle)
        .dynamicTypeSize(.medium ... .accessibility3)
        .lineLimit(1)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.1)
        .accessibilityLabel("Dynamic motivational text")
        .accessibilityValue(ctaText)
        .accessibilityElement(children: .combine)
    }
}
