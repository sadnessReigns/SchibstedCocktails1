//
//  SCOneLineTextField.swift
//  SCComponents
//
//  Created by Uladzislau Makei on 25.05.25.
//

import SwiftUI

public struct SCOneLineTextField: View {

    public enum Style {
        case secure
        case regular
    }

    @Binding private var text: String

    private let strokeColor: Color
    private let style: Style
    private let prompt: String

    public init(
        style: Style = .regular,
        text: Binding<String>,
        strokeColor: Color,
        prompt: String
    ) {
        self.style = style
        self._text = text
        self.strokeColor = strokeColor
        self.prompt = prompt
    }

    public var body: some View {

        textField()
            .padding()
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        strokeColor,
                        lineWidth: 1
                    )
            )
    }

    @ViewBuilder
    private func textField() -> some View {
        switch style {
        case .regular:
            TextField(prompt, text: $text)
                .autocapitalization(.none)
                .textContentType(.username)
        case .secure:
            SecureField(prompt, text: $text)
                .textContentType(.password)
        }
    }
}
