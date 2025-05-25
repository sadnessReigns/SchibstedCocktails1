//
//  SceneDelegate.swift
//  SchibstedCocktails
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: SCAppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        appCoordinator = SCAppCoordinator(window: window)
        appCoordinator?.start()

        prewarmKeyboard()
    }
}

private extension SceneDelegate {

    /// removes first-load keyboard lag from application caused by system's first (app session wise) keyboard invocation 
    func prewarmKeyboard() {
        let textField = UITextField(frame: .zero)
        textField.isHidden = true
        window?.rootViewController?.view.addSubview(textField)

        DispatchQueue.main.async {
            textField.becomeFirstResponder()
            textField.resignFirstResponder()
            textField.removeFromSuperview()
        }
    }

}
