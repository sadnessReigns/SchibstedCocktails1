//
//  SCLoginView.swift
//  SCLogin
//
//  Created by Uladzislau Makei on 24.05.25.
//

import SwiftUI
import SCCommon
import SCComponents

internal struct SCLoginView: View {

    // MARK: - Regular data

    let ctaText: String = "Login to taste cocktails!" // FIXME: should come from localization

    // MARK: - State-reliant data

    @ObservedObject private(set) internal var viewModel: SCLoginViewModel
    @FocusState private(set) internal var focusedField: Field?

    internal init(viewModel: SCLoginViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Code

    var body: some View {

        ZStack {
            logo()
            VStack(alignment: .center) {
                Spacer(minLength: focusedField == nil ? UIScreen.main.bounds.height * 0.2 : 20)

                VStack(alignment: .leading, spacing: 20) {

                    ctaCallout()

                    if focusedField == nil {
                        Spacer()
                    }

                    usernameField()

                    passwordField()

                    if let errorText = viewModel.errorText {
                        SCErrorCallout(impact: .rigid, text: errorText)
                    }

                    loginButton()

                    Spacer()
                }
                .padding(.horizontal, 30)

                if focusedField != nil {
                    Spacer()
                }

                Spacer(minLength: UIScreen.main.bounds.height * 0.15)
            }
            .onTapGesture {
                focusedField = nil
            }
        }
        .animation(.easeInOut(duration: 0.25), value: focusedField)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .backgroundStyle(Color.clear)
    }
}

// MARK: - Intercom API

internal extension SCLoginView {

    func setFocus(to field: Field) {
        focusedField = field
    }
}
