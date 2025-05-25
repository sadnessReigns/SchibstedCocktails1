//
//  SCLoginViewController.swift
//  SCLogin
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit
import SwiftUI

public final class SCLoginViewController: UIViewController {

    private var viewModel: SCLoginViewModel

    private lazy var hostingController: UIHostingController<SCLoginView> = {
        UIHostingController(rootView: SCLoginView(viewModel: viewModel))
    }()

    public init(viewModel: SCLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
