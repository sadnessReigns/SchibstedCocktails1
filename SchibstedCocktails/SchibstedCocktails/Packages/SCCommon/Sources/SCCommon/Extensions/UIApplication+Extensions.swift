//
//  Untitled.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit

public extension UIApplication {

    func availableScreenSize() -> CGFloat {
        let windowScene = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first

        let window = windowScene?.windows.first
        let height = window?.frame.height ?? .zero

        return height
    }
}

